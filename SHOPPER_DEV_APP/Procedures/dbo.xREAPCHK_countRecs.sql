USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xREAPCHK_countRecs]    Script Date: 12/16/2015 15:55:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xREAPCHK_countRecs] as
select UpdTable ='APDOC   ',FieldName ='REFNBR    ',numrecs = count(*) from apdoc A
join  xreapchk X on (A.acct = X.acct and A.sub = X.sub and A.refnbr = X.oldchknbr and doctype in ('HC', 'CK','VC','SC','ZC'))

UNION
select UpdTable ='APTRAN  ',FieldName ='REFNBR    ', numrecs =count(*) from aptran T
join Apdoc A on (T.batnbr = A.batnbr and T.refnbr = A.refnbr and trantype in ('HC', 'CK','VC','SC','ZC'))
join xreapchk X on (A.acct = X.acct and A.sub = X.sub and A.refnbr = X.oldchknbr and doctype in ('HC', 'CK','VC','SC','ZC'))

UNION
select UpdTable = 'APADJUST',FieldName ='ADJGREFNBR', numrecs = count(*) from apadjust J 
join apdoc A on (J.adjgacct = A.acct and J.adjgsub = A.sub and J.adjgrefnbr = A.refnbr and J.adjbatnbr = A.batnbr)
join xreapchk X on ( A.acct = X.acct and A.sub = X.sub and A.refnbr = X.oldchknbr and doctype in ('HC', 'CK','VC','SC','ZC'))

UNION
select UpdTable = 'GLTRAN  ',FieldName ='REFNBR    ', numrecs = count(*) from gltran G
join apdoc A on (G.refnbr = A.refnbr and G.batnbr = A.batnbr and G.id = A.vendid and G.module = 'AP')
join  xreapchk X  on (X.acct = A.acct  and X.sub = A.sub and X.oldchknbr = A.refnbr and A.doctype in ('HC', 'CK','VC','SC','ZC'))
GO
