USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[get_text]    Script Date: 12/21/2015 15:36:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[get_text] @offset int, @numchars int, @ptr varbinary(16)as
readtext snote.snotetext @ptr @offset @numchars
GO
