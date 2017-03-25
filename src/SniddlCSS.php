<?php namespace sniddl\css;

/**
*  A sample class
*
*  Use this section to define what this class is doing, the PHPDocumentator will use this
*  to automatically generate an API documentation using this information.
*
*  @author yourname
*/
class SniddlCSS{

   public $vars;
   public static function run(){
     $root = dirname(__DIR__).'/src/main.rb';
     system(   "ruby $root ".getcwd()  );
   }

   public function scan($f){
     ob_start();
     include $f;

     $this->vars = (object) array();

      $content = file_get_contents($f);
      $tokens = token_get_all($content);

      foreach($tokens as $token){
        if ($token[0] == 312){ //if variable defined in php
          $this->vars->{substr($token[1], 1)} = ${substr($token[1], 1)} ;
        }
        if ($token[0] == 314){ // if called out of php
          preg_match_all('/#{(.*?)}/m', $token[1], $match);
          $this->vars->{print_r($match[1][0], true)} = ${print_r($match[1][0], true)};
        }

      }
      ob_end_clean();
      echo json_encode($this->vars);
   }
}
