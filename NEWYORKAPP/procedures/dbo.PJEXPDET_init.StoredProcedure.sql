USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJEXPDET_init]    Script Date: 12/21/2015 16:01:08 ******/
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
