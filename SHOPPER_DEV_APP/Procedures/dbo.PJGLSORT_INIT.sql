USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJGLSORT_INIT]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJGLSORT_INIT] as
select * from PJGLSORT
where
glsort_key     = 999999999
GO
