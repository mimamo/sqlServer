USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEXPDET_init]    Script Date: 12/16/2015 15:55:26 ******/
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
