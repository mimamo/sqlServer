USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[xTaskkeys_merge]    Script Date: 12/21/2015 15:43:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[xTaskkeys_merge]  as
select * from xTaskkeys where 
mergestat = 1
GO
