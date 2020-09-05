<?
$log = date('Y-m-d H:i:s') . ' post:' . print_r($_POST, true) . PHP_EOL . 'get: ' . print_r($_GET, true);

file_put_contents(__DIR__ . '/log.txt', $log . PHP_EOL, FILE_APPEND);

//if(isset($_POST['filename'])){
//    file_put_contents(__DIR__ . '/'.$_POST['filename'], $_POST['file']);
//}