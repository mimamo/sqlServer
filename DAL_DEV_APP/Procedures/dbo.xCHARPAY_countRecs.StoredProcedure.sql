USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xCHARPAY_countRecs]    Script Date: 12/21/2015 13:35:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xCHARPAY_countRecs] as
select UpdTable ='ARDOC   ',FieldName ='REFNBR      ',numrecs = count(*) from ardoc A
join  xCHARPAY X on (A.custid = X.custid   and A.refnbr = X.oldPayNbr and doctype  in ('PA', 'NS', 'RP'))

UNION
select UpdTable ='ARTRAN  ',FieldName ='REFNBR      ', numrecs =count(*) from aRtran T
join ARdoc A on (T.batnbr = A.batnbr and T.refnbr = A.refnbr and trantype in ('PA', 'NS', 'RP'))
join xCHARPAY X on (A.custid = X.custid and A.refnbr = X.oldPayNbr and doctype in ('PA', 'NS', 'RP'))

UNION
select UpdTable = 'ARADJUST',FieldName ='ADJGREFNBR  ', numrecs = count(*) from aRadjust J 
join aRdoc A on (J.custid = A.custid  and J.adjgrefnbr = A.refnbr and J.adjbatnbr = A.batnbr and J.adjgdoctype in ('PA', 'NS', 'RP'))
join xCHARPAY X on ( A.custid = X.custid  and A.refnbr = X.oldPayNbr and doctype in ('PA', 'NS', 'RP'))
UNION

select UpdTable = 'GLTRAN  ',FieldName ='REFNBR      ', numrecs = count(*) from gltran G
join aRdoc A on (G.refnbr = A.refnbr and G.batnbr = A.batnbr and G.id = A.custid and G.module = 'AR')
join  xCHARPAY X  on (X.custid = A.custid  and   X.oldPayNbr = A.refnbr and A.doctype in ('PA', 'NS', 'RP'))

select UpdTable = 'PJARPAY ',FieldName ='CHECK_REFNBR', numrecs = count(*) from pjarpay P
join aRdoc A on (P.check_refnbr = A.refnbr and P.custid = A.custid )
join xCHARPAY X on (A.custid = X.custid and A.refnbr = X.oldPayNbr and A.doctype in ('PA', 'NS', 'RP'))
GO
