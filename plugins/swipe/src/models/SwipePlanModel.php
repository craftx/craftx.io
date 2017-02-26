<?php
namespace selvinortiz\swipe\models;

use craft\base\Model;

class SwipePlanModel extends Model {
    /**
     * @var string
     */
    public $id;

    /**
     * @var string
     */
    public $name;
    
    /**
     * @var string
     */
    public $amount;
    
    /**
     * @var string (day|week|month|year)
     */
    public $interval = 'month';

    /**
     * @var int
     */
    public $intervalCount = 1;

    /**
     * @var string
     */
    public $currency = 'usd';

    /**
     * @var string
     */
    public $statementDescription = 'Craft X';

    public $fieldMap = [
        'intervalCount' => 'interval_count',
        'statementDescription' => 'statement_descriptor',
    ];

    public function amount() {
        return number_format(($this->amount/100), 2);
    }
}
