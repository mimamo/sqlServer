USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABDET_init]    Script Date: 12/21/2015 16:07:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLABDET_init]
as
select * from PJLABDET
where    docnbr     =  'Z' and
linenbr    = 9
GO
