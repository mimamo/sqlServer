USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xkccustinv_Descr]    Script Date: 12/21/2015 13:36:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkccustinv_Descr]  as
update xkccustinv set fromname = C.name
from xkccustinv X
join customer C on X.fromkey = C.custid
update xkccustinv set toname =C.name
from xkccustinv X
join customer C  on X.tokey = C.custid
GO
