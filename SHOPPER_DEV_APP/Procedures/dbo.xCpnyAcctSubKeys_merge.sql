USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xCpnyAcctSubKeys_merge]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[xCpnyAcctSubKeys_merge]  as
select * from xCpnyAcctSubKeys where 
mergestat = 1
GO
