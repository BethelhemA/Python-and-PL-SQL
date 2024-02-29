CREATE OR REPLACE TYPE MinitermFragment AS TABLE OF VARCHAR2(100);

CREATE OR REPLACE TYPE Predicate AS OBJECT (
    predicate_name VARCHAR2(100),
    args VARCHAR2(100)
);

CREATE OR REPLACE TYPE PredicateList AS TABLE OF Predicate;

CREATE OR REPLACE TYPE MinitermTable AS TABLE OF MinitermFragment;

CREATE OR REPLACE PROCEDURE GenerateMiniterms(predicates IN PredicateList, miniterms OUT MinitermTable) AS
    new_miniterms MinitermTable := MinitermTable();
BEGIN
    FOR i IN 1..predicates.COUNT LOOP
        new_miniterms := new_miniterms MULTISET UNION GenerateMinitermsFromPredicate(predicates(i));
    END LOOP;
    miniterms := new_miniterms;
END;

CREATE OR REPLACE FUNCTION GenerateMinitermsFromPredicate(predicate IN Predicate) RETURN MinitermTable PIPELINED AS
    miniterm_fragment MinitermFragment := MinitermFragment();
BEGIN
    miniterm_fragment := MinitermFragment();
    miniterm_fragment.EXTEND;
    miniterm_fragment(1) := predicate.predicate_name;
    
    FOR i IN 1..LENGTH(predicate.args) LOOP
        FOR j IN 1..LENGTH(predicate.args(i)) LOOP
            miniterm_fragment.EXTEND;
            miniterm_fragment(miniterm_fragment.COUNT) := predicate.args(i)(j);
            PIPE ROW(miniterm_fragment);
        END LOOP;
    END LOOP;
    
    RETURN;
END;
