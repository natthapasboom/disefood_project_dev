<?php

namespace App\Http\Controllers;

use App\Http\Requests\CreatePaymentRequest;
use App\Models\Payment\Payment;
use App\Repositories\Interfaces\OrderRepositoryInterface;
use App\Repositories\Interfaces\PaymentRepositoryInterface;
use App\Repositories\Interfaces\ShopRepositoryInterface;
use Google\ApiCore\ApiException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Auth;
use Google\Cloud\Vision\V1\ImageAnnotatorClient;

class PaymentController extends Controller
{
    private $payment;
    private $order;
    private $shop;

    public function __construct
    (
        PaymentRepositoryInterface $paymentRepo,
        OrderRepositoryInterface $orderRepo,
        ShopRepositoryInterface $shopRepo
    )
    {
        $this->payment = $paymentRepo;
        $this->order = $orderRepo;
        $this->shop = $shopRepo;
    }

    public function getAllPayments()
    {
        $payments = $this->payment->getAll();
        return response()->json(['data' => $payments], 200);
    }

    public function getPaymentById($paymentId)
    {
        $payment = $this->payment->getById($paymentId);

        if(!$payment) return response()->json(['msg' => 'Payment not found'], 404);

        return response()->json(['data' => $payment], 200);
    }

    public function getPaymentByOrderId($orderId)
    {
        $user = Auth::user();
        $userId = $user['id'];
        $order = $this->order->getById($orderId);

        if (!$order) return response()->json(['msg' => 'Order not found'], 404);

        $orderId = $order->id;
        if ( !$this->isOwnerOrder($userId, $orderId) ) return response()->json(['msg' => 'No Permission'], 401);

        $payment = $this->payment->getByOrderId($orderId);
        $payment->order;
        if (!$payment) return response()->json(['msg' => 'Payment not found'], 404);

        return response()->json(['data' => $payment, 'msg' => 'Payment of your Order'], 200);
    }

    public function checkPayInFullAmount($orderId)
    {
        $order = $this->order->getById($orderId);
        $order->payment;
        $orderAmount = $order->total_price;
        $payAmount = $order->payment->amount;
        $msg = null;
        $different = null;
        if ($payAmount < $orderAmount) {
            $msg = "Payment's amount is less than Order's price";
            $different = $orderAmount-$payAmount;
        } elseif ($payAmount > $orderAmount) {
            $msg = "Payment's amount is more than Order's price";
            $different = $payAmount-$orderAmount;
            $newOrder['status'] = 'in process';
            $newOrder['confirmed_by_customer'] = true;
            $this->order->updateById($orderId, $newOrder);
        } else {
            $msg = "Payment's amount is equal Order's price";
            $different = 0;
            $newOrder['status'] = 'in process';
            $newOrder['confirmed_by_customer'] = true;
            $this->order->updateById($orderId, $newOrder);
        }
        $data['msg'] = $msg;
        $data['different'] = $different;
        return response()->json(['data' => $data, 'msg' => 'check amount is success'], 200);
    }

    public function orderPaymentConfirmation($orderId)
    {
        $newOrder['confirmed_by_customer'] = true;
        $this->order->updateById($orderId, $newOrder);
        $order = $this->order->getById($orderId);
        return response()->json(['data' => $order, 'msg' => 'Confirm Order success'], 200);
    }

    public function create(CreatePaymentRequest $request, $orderId)
    {
        $imageAnnotator = new ImageAnnotatorClient();
        try {
            $user = Auth::user();
            $userId = $user['id'];
            $order = $this->order->getById($orderId);

            if( !$order ) {
                return response()->json(['msg' => 'Order not found'], 404);
            }

            $orderId = $order->id;

            if ( !$this->isOwnerOrder($userId, $orderId)) {
                return response()->json(['msg' => 'No Permission'], 401);
            }

            $req = $request->validated();

            if(!$req) {
                return response()->json(['msg' => 'Failed Validation'], 422);
            }

            $pathImg = Storage::disk('s3')->put('images/payment', $request->file('payment_img'),'public');
            $imgName = 'https://disefood.s3-ap-southeast-1.amazonaws.com/'.$pathImg;
            $image = file_get_contents($imgName);
            $response = $imageAnnotator->textDetection($image);
            $texts = $response->getTextAnnotations();

            foreach ($texts as $text) {
                $word = strtolower($text->getDescription());
                $wordForSCBBank = $text->getDescription();
                $bankType = null;
                $language = null;
                $checkBank = substr($word, 0, 50);

                switch ($checkBank) {

                    case strpos($checkBank, "bangkok bank") !== false :

                        if (strpos($word, "รายการสำเร็จ") !== false)                { $language = "THAI"; }
                        if (strpos($word, "transaction successful") !== false)   { $language = "ENGLISH"; }

                        $wordNotHaveSpace = str_replace(' ','', $word);
                        if ($language == "THAI" ) {
                            $transactionId = $this->get_string_between($wordNotHaveSpace, "เลขที่อ้างอิง", "สแกนเพื่อตรวจสอบ");
                            $amount = $this->get_string_between($wordNotHaveSpace, "จำนวนเงิน", "thb");
                            $date = $this->get_string_between($word, "รายการสำเร็จ", "จำนวนเงิน");
                            $engDate = $this->changeThaiToEngDate($date);
                            $engYear = $this->changeBEYearToADYear($engDate);
                            $newDate = strtotime($engYear);

                        } elseif  ($language == "ENGLISH") {
                            $transactionId = $this->get_string_between($wordNotHaveSpace, "transactionreference", "scan");
                            $amount = $this->get_string_between($wordNotHaveSpace, "amount", "thb");
                            $date = $this->get_string_between($word, "successful", "amount");
                            $newDate = strtotime($date);

                        } else {
                            return response()->json(['msg' => 'This slip is not a money transfer method.'], 200);
                        }

                        $editTransactionId = substr($transactionId,1, 25);
                        $editAmount = substr($amount,1);
                        $dateFormat = date('Y-m-d H:i:s', $newDate);
                        $bankType = "BUA_LUANG";
                        break;

                    case strpos($checkBank, "k+") !== false :
                        if (strpos($word, "transfer completed") !== false)   { $language = "ENGLISH"; }
                        if (strpos($word, "โอนเงินสำเร็จ") !== false)                { $language = "THAI"; }

                        $wordNotHaveSpace = str_replace(' ','', $word);

                        if ($language == "THAI") {
                            $transactionId = $this->get_string_between($wordNotHaveSpace, "เลขที่รายการ", "จำนวน");
                            $amount = $this->get_string_between($wordNotHaveSpace, "จำนวน", "บาท");
                            $date = $this->get_string_between($word, "k+", "น.");
                            $engDate = $this->changeThaiToEngDate($date);
                            $engYear = $this->changeBEYearToADYear($engDate);
                            $newDate = strtotime($engYear);

                        } elseif ($language == "ENGLISH") {
                            $transactionId = $this->get_string_between($wordNotHaveSpace, "transactionid:", "amount");
                            $amount = $this->get_string_between($wordNotHaveSpace, "amount:", "baht");

                            if (strpos($word, "am") !== false) {
                                $date = $this->get_string_between($word, "k+", "am") . "am";
                            }

                            if (strpos($word, "pm") !== false) {
                                $date = $this->get_string_between($word, "k+", "pm") . "pm";
                            }

                            $newDate = strtotime($date);
                        } else {
                            return response()->json(['msg' => 'This slip is not a money transfer method.'], 200);
                        }

                        $editTransactionId = substr($transactionId,1, 18);
                        $editAmount = substr($amount,1);
                        $dateFormat = date('Y-m-d H:i:s', $newDate);
                        $bankType = "K_BANK";
                        break;

                    case strpos($checkBank, "krungsri") !== false :
                        if (strpos($word, "fund transfer") !== false)   { $language = "ENGLISH"; }
                        if (strpos($word, "โอนเงินสำเร็จ") !== false)                { $language = "THAI"; }

                        $wordNotHaveSpace = str_replace(' ','', $word);

                        if ($language == "THAI") {
                            $transactionId = substr($wordNotHaveSpace, strpos($wordNotHaveSpace, "อ้างอิง") + 1);
                            $newTransactionId = substr($transactionId,21, 13);
                            $amount = $this->get_string_between($wordNotHaveSpace, "จำนวนเงิน", "thb");
                            $date = date('Y-m-d H:i:s');
                            $newDate = strtotime($date);

                        } elseif ($language == "ENGLISH") {
                            $transactionId = substr($wordNotHaveSpace, strpos($wordNotHaveSpace, "refno.") + 1);
                            $newTransactionId = substr($transactionId, 6, 13);
                            $amount = $this->get_string_between($wordNotHaveSpace, "amount", "thb");
                            $date = date('Y-m-d H:i:s');
                            $newDate = strtotime($date);
                        } else {
                            return response()->json(['msg' => 'This slip is not a money transfer method.'], 200);
                        }

                        $editTransactionId = $newTransactionId;
                        $editAmount = substr($amount, 1);
                        $dateFormat = date('Y-m-d H:i:s', $newDate);
                        $bankType = "KRUNG_SRI";
                        break;

                    case strpos($checkBank, "krungthai") !== false :

                        if (strpos($word, "transfer completed") !== false)   { $language = "ENGLISH"; }
                        if (strpos($word, "โอนเงินสำเร็จ") !== false)                { $language = "THAI"; }

                        $wordNotHaveSpace = str_replace(' ','', $word);

                        if ($language == "THAI") {
                            $pattern = "/krungthai/i";
                            $pattern2 = "/krungt/i";
                            $newWord = preg_replace($pattern, '', $word);
                            $newWord2 = preg_replace($pattern2, '', $newWord);
                            $wordForGetTranId = substr($newWord2, strpos($newWord2, "skadiv")+1);
                            $wordForGetAmount = substr($newWord2, strpos($newWord2, "siu")+1);
                            preg_match("([0-9,]+.[0-9]{2})", $wordForGetAmount, $matches);

                            $transactionId = substr($wordForGetTranId, 9, 16);
                            $newTransactionId = $transactionId;
                            $amount = $matches[0];
                            $newAmount = $amount;
                            $date = date('Y-m-d H:i:s');
                            $newDate = strtotime($date);
                        } elseif ($language == "ENGLISH") {
                            $transactionId = substr($wordNotHaveSpace, strpos($wordNotHaveSpace, "no.")+1);
                            $newTransactionId = substr($transactionId,2, 16);
                            $amount = $this->get_string_between($wordNotHaveSpace, "amount", "thb");
                            preg_match("([0-9,]+.[0-9]{2})", $amount, $matches);
                            if (strpos($amount, ",") !== false) {
                                $wordForGetAmount = str_replace("," , "", $amount);
                            }
                            preg_match("!\d+!", $wordForGetAmount, $matches);
                            $newAmount = $matches[0];

                            $date = $this->get_string_between($word, "date", "krungthai");
                            $editDate = str_replace("-", "", $date);
                            $newDate = strtotime($editDate);
                        } else {
                            return response()->json(['msg' => 'This slip is not a money transfer method.'], 200);
                        }

                        $editTransactionId = $newTransactionId;
                        $editAmount = $newAmount;
                        $dateFormat = date('Y-m-d H:i:s', $newDate);
                        $bankType = "KRUNG_THAI";
                        break;

                    case strpos($checkBank, "scb") !== false :
                        if (strpos($word, "successful transfer") !== false)   { $language = "ENGLISH"; }
                        if (strpos($word, "โอนเงินสำเร็จ") !== false)                { $language = "THAI"; }

                        $wordNotHaveSpace = str_replace(' ','', $wordForSCBBank);
                        if ($language == "ENGLISH") {

                            $transactionId = $this->get_string_between($wordNotHaveSpace, "RefID:", "FROM");
                            $newTransactionId = substr($transactionId, 0, 25);
                            $amount = $this->get_string_between($wordNotHaveSpace, "AMOUNT", "For");
                            $date = $this->get_string_between($wordForSCBBank, "transfer", "Ref");
                            $editDate = str_replace("-", "", $date);
                            $newDate = strtotime($editDate);
                            preg_match("([0-9,]+.[0-9]{2})", $amount, $matches);
                            $newAmount = $matches[0];
                        } elseif ($language == "THAI") {
                            $transactionId = $this->get_string_between($wordNotHaveSpace, "รหัสอ้างอิง:", "จาก");

                            preg_match("([0-9a-zA-Z]{25})", $transactionId, $transactionIDMatches);
                            $regexTransactionID = $transactionIDMatches[0];
                            if (strpos($regexTransactionID, "\n") !== false) {
                                $newTransactionId = str_replace("\n", "", $regexTransactionID);
                            } else {
                                $newTransactionId = $regexTransactionID;
                            }

                            $amount = $this->get_string_between($wordNotHaveSpace, "จำนวนเงิน", "ผู้รับเงิน");
                            preg_match("([0-9,]+.[0-9]{2})", $amount, $matches);
                            $newAmount = $matches[0];
                            $date = $this->get_string_between($word, "โอนเงินสำเร็จ", "รหัสอ้างอิง");
                            $editDate = str_replace("-", "", $date);
                            $engDate = $this->changeThaiToEngDate($editDate);
                            $engYear = $this->changeBEYearToADYear4digits($engDate);
                            $newDate = strtotime($engYear);
                        } else {
                            return response()->json(['msg' => 'This slip is not a money transfer method.'], 200);
                        }

                        $editTransactionId = $newTransactionId;
                        $editAmount = $newAmount;
                        $dateFormat = date('Y-m-d H:i:s', $newDate);
                        $bankType = "SCB";
                        break;

                    default :
                        return response()->json(['msg' => 'not found any bank-type in this image'], 200);
                }

                if (strpos($editAmount, ",") !== false) {
                    $editAmount = str_replace("," , "", $editAmount);
                }

                $req['order_id'] = $orderId;
                $req['transaction_id'] =$editTransactionId;
                $req['amount'] = $editAmount;
                $req['payment_date'] = $dateFormat;
                $req['payment_img'] = $pathImg;

                $data = $this->payment->create($req);

                $req['bank-type'] = $bankType;
                $req['language']  = $language;

                return response()->json(['data' => $data, 'msg' => 'Create payment successful'], 200);
            }

            $imageAnnotator->close();

        } catch (ApiException $error) {
            echo 'Caught exception: ',  $error->getMessage();
        }
    }

    private function get_string_between($string, $start, $end){
        $string = ' ' . $string;
        $ini = strpos($string, $start);
        if ($ini == 0) return '';
        $ini += strlen($start);
        $len = strpos($string, $end, $ini) - $ini;
        return substr($string, $ini, $len);
    }

    private function isOwnerOrder($userId, $orderId) {
        $isOwner = null;
        $order = $this->order->getById($orderId);
        if ($order->user_id == $userId) {
            $isOwner = true;
        } else {
            $isOwner = false;
        }
        return $isOwner;
    }

    public function isShopOwnerOrder($userId, $orderId) {
        $isShopOwnerOrder = null;
        $order = $this->order->getById($orderId);
        $shopId = $order->shop_id;
        $shop = $this->shop->findById($shopId);
        if( $shop['user_id'] == $userId ){
            $isShopOwnerOrder = true;
        } else {
            $isShopOwnerOrder = false;
        }
        return $isShopOwnerOrder;
    }

    private function changeThaiToEngDate($thaiDate) {
        $search = [
            'ม.ค.',            'ก.พ.',
            'มี.ค.',            'เม.ย.',
            'พ.ค.',            'มิ.ย.',
            'ก.ค.',            'ส.ค.',
            'ก.ย.',            'ต.ค.',
            'พ.ย.',            'ธ.ค.'
        ];

        $replace = [
            'jan',            'feb',
            'mar',            'apr',
            'may',            'jun',
            'jul',            'aug',
            'sep',            'oct',
            'nov',            'dec'
        ];

        return str_replace($search, $replace, $thaiDate);
    }

    private function changeBEYearToADYear($thaiYear) {
        $search = [
            '63', '64', '2563', '2564'
        ];
        $replace = [
          '20', '21', '2020', '2021'
        ];
        return str_replace($search, $replace, $thaiYear);
    }

    private function changeBEYearToADYear4digits($thaiYear) {
        $search = [
            '2563', '2564'
        ];
        $replace = [
            '2020', '2021'
        ];
        return str_replace($search, $replace, $thaiYear);
    }
}
