USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xREAPCHK_UpdateTables]    Script Date: 12/21/2015 14:06:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xREAPCHK_UpdateTables] as
update APTRAN  set refnbr = X.newchknbr
from aptran T 
join Apdoc A on (T.batnbr = A.batnbr and T.refnbr = A.refnbr and trantype in ('HC', 'CK','VC','SC','ZC'))
join xreapchk X on (A.acct = X.acct and A.sub = X.sub and A.refnbr = X.oldchknbr and doctype in ('HC', 'CK','VC','SC','ZC'))

update APADJUST set adjgrefnbr = X.newchknbr
from apadjust J 
join apdoc A on (J.adjgacct = A.acct and J.adjgsub = A.sub and J.adjgrefnbr = A.refnbr and J.adjbatnbr = A.batnbr)
join xreapchk X on ( A.acct = X.acct and A.sub = X.sub and A.refnbr = X.oldchknbr and doctype in ('HC', 'CK','VC','SC','ZC'))

update GLTRAN set refnbr = X.newchknbr 
from gltran G 
join apdoc A on (G.refnbr = A.refnbr and G.batnbr = A.batnbr and G.id = A.vendid and G.module = 'AP')
join  xreapchk X  on (X.acct = A.acct  and X.sub = A.sub and X.oldchknbr = A.refnbr and A.doctype in ('HC', 'CK','VC','SC','ZC'))

update APDOC set refnbr = X.newchknbr
from apdoc A 
join  xreapchk X on (A.acct = X.acct and A.sub = X.sub and A.refnbr = X.oldchknbr and doctype in ('HC', 'CK','VC','SC','ZC'))
GO
