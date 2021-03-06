USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xCHARPAY_UpdateTables]    Script Date: 12/21/2015 14:18:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xCHARPAY_UpdateTables] as
update ARTran  set refnbr = X.NewPayNbr
from ARTran T 
join ARdoc A on (T.batnbr = A.batnbr and T.refnbr = A.refnbr and trantype in ('PA', 'NS', 'RP'))
join xCHARPAY X on (A.custid = X.custid and A.refnbr = X.oldPayNbr and doctype in ('PA', 'NS', 'RP'))

update ARADJUST set adjgrefnbr = X.NewPayNbr
from ARADJUST J 
join aRdoc A on (J.custid = A.custid and J.adjgrefnbr = A.refnbr and J.adjbatnbr = A.batnbr and J.adjgdoctype in ('PA', 'NS', 'RP'))
join xCHARPAY X on ( A.custid = X.custid  and A.refnbr = X.oldPayNbr and doctype in ('PA', 'NS', 'RP'))

update GLTRAN set refnbr = X.NewPayNbr 
from gltran G 
join aRdoc A on (G.refnbr = A.refnbr and G.batnbr = A.batnbr and G.id = A.custid and G.module = 'AR')
join  xCHARPAY X  on (X.custid = A.custid  and   X.oldPayNbr = A.refnbr and A.doctype in ('PA', 'NS', 'RP'))

update ARDoc set refnbr = X.NewPayNbr
from aRdoc A 
join  xCHARPAY X on (A.custid = X.custid   and A.refnbr = X.oldPayNbr and doctype  in ('PA', 'NS', 'RP'))

update PJARPAY set check_refnbr = X.NewPayNbr
from pjarpay P
join aRdoc A on (P.check_refnbr = A.refnbr and P.custid = A.custid )
join xCHARPAY X on (A.custid = X.custid and A.refnbr = X.oldPayNbr and A.doctype in ('PA', 'NS', 'RP'))
GO
