<?php 
$basPath = dirname($argv[1]) . '/';
$data = file_get_contents($argv[1]);
$data = json_decode($data,true);


foreach($data as $schema){
    $className = $schema['class'];
    $colmuns = $schema['columns'];
    
    $outputH = <<< __EOM__
    
   
#import <Foundation/Foundation.h>
#import "TokoModel.h"

@interface {$className} : TokoModel

__EOM__;

    foreach ($colmuns as $name => $value) {
        $classType = '';
        if($value['type'] == 'integer' || $value['type'] == 'int'){
            $classType = 'NSNumber';
        }else if($value['type'] == 'float' || $value['type'] == 'double' || $value['type'] == 'real'){
            $classType = 'NSString';
        }else if($value['type'] == 'text' || $value['type'] == 'string'){
            $classType = 'NSString';
        }else if($value['type'] == 'blob' ){
            $classType = 'NSData';
        }
        
        $outputH .= "@property (retain,nonatomic) {$classType} *{$name};\n";
    }

    $outputH .= <<< __EOM__

@end
        
__EOM__;
    
    file_put_contents($basPath . $className . '.h',$outputH);
    echo "output to " . $basPath . $className . ".h\n";
    
    
    $outputM = <<< __EOM__
    
#import "{$className}.h"
@implementation {$className}

__EOM__;
    foreach ($colmuns as $name => $value) {
        $outputM .= "@dynamic {$name};\n";
    }


    $outputM .= <<< __EOM__


@end
__EOM__;

    file_put_contents($basPath . $className . '.m',$outputM);
    echo "output to " . $basPath . $className . ".m\n";
    
}
