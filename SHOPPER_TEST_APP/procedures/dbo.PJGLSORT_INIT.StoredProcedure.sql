USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJGLSORT_INIT]    Script Date: 12/21/2015 16:07:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJGLSORT_INIT] as
select * from PJGLSORT
where
glsort_key     = 999999999
GO
