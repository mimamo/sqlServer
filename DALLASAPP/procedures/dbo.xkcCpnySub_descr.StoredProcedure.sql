USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xkcCpnySub_descr]    Script Date: 12/21/2015 13:45:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcCpnySub_descr]  as
update xkcCpnySub set fromdescr = A.descr
from xkcCpnySub X
join Subacct A on x.FromKey = A.Sub  
update xkcCpnySub set todescr  = A.descr
from xkcCpnySub X
join Subacct A on x.Tokey = A.Sub
GO
