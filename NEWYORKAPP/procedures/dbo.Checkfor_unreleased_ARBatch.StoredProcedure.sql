USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[Checkfor_unreleased_ARBatch]    Script Date: 12/21/2015 16:00:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[Checkfor_unreleased_ARBatch] AS
select * from batch where rlsed = 0 and Status <> 'V' and module = "AR"
GO
