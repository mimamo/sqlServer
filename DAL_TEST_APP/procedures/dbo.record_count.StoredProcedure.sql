USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[record_count]    Script Date: 12/21/2015 13:57:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[record_count] @parm1 varchar (50) as
exec ('select TotRecs =  count (*) from ' + @parm1 )
GO
