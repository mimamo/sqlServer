USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[acctsubkeys_merge]    Script Date: 12/21/2015 14:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[acctsubkeys_merge]  as
select * from acctsubkeys where 
mergestat = 1
GO
