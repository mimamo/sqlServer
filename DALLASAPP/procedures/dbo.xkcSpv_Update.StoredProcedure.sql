USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xkcSpv_Update]    Script Date: 12/21/2015 13:45:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcSpv_Update] as
delete from xkcSpv
insert  xkcSpv (subacct) select sub from subacct
GO
