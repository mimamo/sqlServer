USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Checkfor_unreleased_ARBatch]    Script Date: 12/21/2015 14:05:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[Checkfor_unreleased_ARBatch] AS
select * from batch where rlsed = 0 and Status <> 'V' and module = "AR"
GO
