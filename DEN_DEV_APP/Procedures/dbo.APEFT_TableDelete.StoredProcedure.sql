USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APEFT_TableDelete]    Script Date: 12/21/2015 14:05:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[APEFT_TableDelete]

as
	declare @TblName varchar(30)

	declare MMGCursor cursor for select name from sysobjects where substring(name,1,8) = 'APEFTOld' and  sysstat & 0xf = 3

	open MMGCursor
	fetch next from MMGCursor into @TblName

	while (@@fetch_status = 0)
	begin
		exec('drop table ' + @TblName)

		fetch next from MMGCursor into @TblName
	end

	close MMGCursor
	deallocate MMGCursor
GO
