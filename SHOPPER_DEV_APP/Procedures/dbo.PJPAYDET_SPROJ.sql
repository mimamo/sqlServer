USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPAYDET_SPROJ]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPAYDET_SPROJ]  @parm1 varchar (16)  as
select * from PJPAYDET
where
PJPAYDET.project       =    @parm1
GO
