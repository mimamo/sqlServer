USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJTIMWRK_dbatch]    Script Date: 12/21/2015 15:49:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTIMWRK_dbatch] @parm1 varchar (10) as
delete from PJTIMWRK
where Report_accessnbr = @parm1
GO
