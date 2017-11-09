<?php

// See: http://php.net/manual/ru/language.oop5.traits.php

class SomeParent
{
    public function whereAmi() : string
    {
        return 'In parent';
    }
}


trait SomeTrait
{
    public function whereAmi() : string
    {
        return 'In trait';
    }
}

class Some extends SomeParent
{
    use SomeTrait;

    public function whereAmi() : string
    {
        return 'In class and '.strtolower(parent::whereAmi());
    }
}

var_dump((new Some)->whereAmi());
