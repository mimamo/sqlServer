USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xkcCpnyAcct_descr]    Script Date: 12/21/2015 13:45:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcCpnyAcct_descr]  as
update xkcCpnyAcct set fromdescr = A.descr
from xkcCpnyAcct X
join Account A on x.fromkey = A.acct  
update xkcCpnyAcct set todescr  = A.descr
from xkcCpnyAcct X
join Account A on x.tokey = A.acct
GO
