USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEXPDET_SMAXLINE]    Script Date: 12/21/2015 14:34:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEXPDET_SMAXLINE]  @parm1 varchar (10)   as
select max(linenbr) from PJEXPDET
where    docnbr     =  @parm1
GO
