USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[acctsubkeys_merge]    Script Date: 12/21/2015 13:44:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[acctsubkeys_merge]  as
select * from acctsubkeys where 
mergestat = 1
GO
