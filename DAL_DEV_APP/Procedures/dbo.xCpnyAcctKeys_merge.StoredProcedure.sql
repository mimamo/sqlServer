USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xCpnyAcctKeys_merge]    Script Date: 12/21/2015 13:35:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[xCpnyAcctKeys_merge]  as
select * from xCpnyAcctKeys where 
mergestat = 1
GO
