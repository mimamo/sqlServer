USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARTRAN_uRELEASE]    Script Date: 12/21/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ARTRAN_uRELEASE] @parm1 varchar (10) as
update ARTRAN set rlsed=1
where batnbr = @parm1
GO
