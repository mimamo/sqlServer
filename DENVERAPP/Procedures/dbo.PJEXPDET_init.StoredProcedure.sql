USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJEXPDET_init]    Script Date: 12/21/2015 15:43:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEXPDET_init]
as
select * from PJEXPDET
where    docnbr     =  'Z' and
linenbr    = 9
GO
