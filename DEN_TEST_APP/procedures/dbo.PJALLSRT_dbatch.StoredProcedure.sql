USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJALLSRT_dbatch]    Script Date: 12/21/2015 15:37:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJALLSRT_dbatch] @parm1 varchar (10) as
delete from PJALLSRT
where alloc_batch = @parm1
GO
