USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARDOC_uRELEASE]    Script Date: 12/21/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ARDOC_uRELEASE] @parm1 varchar (10) as
update ARDOC set rlsed=1
where batnbr = @parm1
GO
