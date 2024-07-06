set i /1*30/
    j /1*30/
    k /1*30/;

* Parameters and Scalars

parameter f(i)  Fixed cost incurred if ambulance station is located at i
$call GDXXRW input_data.xlsx par=f rng=Sheet24!a98:b127  cdim=1 rdim=0
$GDXIN input_data.gdx
$Load f
$GDXIN

parameter cost_asp(i,j)  Cost from ambulance station i to patient j
$call GDXXRW input_data.xlsx par=cost_asp rng=Sheet24!a130:ae160  cdim=1 rdim=1
$GDXIN input_data.gdx
$Load cost_asp
$GDXIN

parameter cost_ph(j,k)   Cost from patient j to hospital k
$call GDXXRW input_data.xlsx par=cost_ph rng=Sheet24!a164:ae194  cdim=1 rdim=1
$GDXIN input_data.gdx
$Load cost_ph
$GDXIN

parameter cost_has(k,i)  Cost from hospital k to ambulance station
$call GDXXRW input_data.xlsx par=cost_has rng=Sheet24!a198:ae228  cdim=1 rdim=1
$GDXIN input_data.gdx
$Load cost_has
$GDXIN

parameter capas(i)       Ambulance station capacity
$call GDXXRW input_data.xlsx par=capas rng=Sheet24!a34:b63  cdim=1 rdim=0
$GDXIN input_data.gdx
$Load capas
$GDXIN

parameter caph(k)       Hospital capacity
$call GDXXRW input_data.xlsx par=caph rng=Sheet24!a2:b31  cdim=1 rdim=0
$GDXIN input_data.gdx
$Load caph
$GDXIN

parameter p(j)           Patients in each ward
$call GDXXRW input_data.xlsx par=p rng=Sheet24!a66:b95  cdim=1 rdim=0
$GDXIN input_data.gdx
$Load p
$GDXIN

Scalar budget /100000/;

* Variables

Binary variable y(i)  Ambulance station located at i (0 or 1);

Positive variable
    xnasp(i,j),
    xnph(j,k),
    xnhas(k,i);

Free variable z;

Equations
    eq1(i)    Constraint 1
    eq2(j)    Constraint 2
    eq3(j)    Constraint 3
    eq4(k)    Constraint 4
    eq5(i,j)  Constraint 5
    eq6(i)    Constraint 6
    eq7(k)    Constraint 7
    eq8(i)    Constraint 8
    eq9(i)    Constraint 9
    eq10      Constraint 10
    eq11(i)   Constraint 11
    obj_fn    objective function
    budgetConstraint budget available;

* Constraints

eq1(i)..     sum(j, xnasp(i,j)) =l= capas(i);
eq2(j)..     sum(i, xnasp(i,j)) =e= p(j);
eq3(j)..     sum(i, xnasp(i,j)) =e= sum(k, xnph(j,k));
eq4(k)..     sum(j, xnph(j,k)) =l= caph(k);
eq5(i,j)..   xnasp(i,j) =l= y(i) * p(j);
eq6(i)..     sum(j, xnasp(i,j)) =l= y(i)*capas(i);
eq7(k)..     sum(j, xnph(j,k)) =e= sum(i, xnhas(k,i));
eq8(i)..     sum(k, xnhas(k,i)) =e= sum(j, xnasp(i,j));
eq9(i)..     sum(k, xnhas(k,i)) =l= capas(i);
eq10..       sum(i, y(i)*capas(i)) =g= sum(j, p(j));
eq11(i)..    sum(k, xnhas(k,i)) =l= capas(i)*y(i);

* Objective Function

obj_fn..  z =e= sum(i, f(i)*y(i)) + sum((i,j), xnasp(i,j)*cost_asp(i,j)) +
               sum((j,k), xnph(j,k)*cost_ph(j,k)) + sum((k,i), xnhas(k,i)*cost_has(k,i));

* Budget Constraint

budgetConstraint.. sum((i,j), xnasp(i,j)) =l= budget;

* Model Definition

model AS /all/;

AS.nodlim = 1e9;

$onecho > sbb.opt
*memnodes 1e6
$offecho

AS.optcr=0;
AS.iterlim=1000000000;
AS.reslim=1000000000;
AS.solvelink = 2;
AS.optfile = 1;

option minlp = sbb;

solve AS minimizing z using minlp;

display y.l, xnasp.l, xnph.l, xnhas.l, z.l;
