USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xTaskkeys_merge]    Script Date: 12/21/2015 13:57:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[xTaskkeys_merge]  as
select * from xTaskkeys where 
mergestat = 1
GO
