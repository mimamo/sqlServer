USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPAYDET_SPROJ]    Script Date: 12/21/2015 16:13:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPAYDET_SPROJ]  @parm1 varchar (16)  as
select * from PJPAYDET
where
PJPAYDET.project       =    @parm1
GO
