USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[xCpnyAcctSubKeys_merge]    Script Date: 12/21/2015 16:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[xCpnyAcctSubKeys_merge]  as
select * from xCpnyAcctSubKeys where 
mergestat = 1
GO
