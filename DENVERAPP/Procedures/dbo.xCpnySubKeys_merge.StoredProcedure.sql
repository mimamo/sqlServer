USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[xCpnySubKeys_merge]    Script Date: 12/21/2015 15:43:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[xCpnySubKeys_merge]  as
select * from xCpnySubKeys where 
mergestat = 1
GO
