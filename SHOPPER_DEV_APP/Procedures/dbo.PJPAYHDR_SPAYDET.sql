USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPAYHDR_SPAYDET]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPAYHDR_SPAYDET]  @parm1 varchar (16) as
select PJPAYHDR.* from PJPAYDET, PJPAYHDR
where
PJPAYDET.project       =    @parm1
and  PJPAYDET.project       =    PJPAYHDR.project
and  PJPAYDET.subcontract   =    PJPAYHDR.subcontract
and  PJPAYDET.payreqnbr     =    PJPAYHDR.payreqnbr
and  PJPAYHDR.status1     <> 'P'
GO
