USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJALLGL_INIT]    Script Date: 12/21/2015 15:49:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJALLGL_INIT] as
select * from PJALLGL
where
alloc_batch    = ' ' and
glsort_key     = 0
GO
