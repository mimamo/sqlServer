USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARDOC_uRELEASE]    Script Date: 12/21/2015 13:44:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ARDOC_uRELEASE] @parm1 varchar (10) as
update ARDOC set rlsed=1
where batnbr = @parm1
GO
