USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[xkcinvls_Descr]    Script Date: 12/21/2015 15:43:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcinvls_Descr]  as
update xkcinvls set invtid_descr = L.invtid_descr
from xkcinvls X
join xlotsermst L on X.invtid = L.invtid
GO
