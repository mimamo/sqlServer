USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOMMUN_spk4]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCOMMUN_spk4] @parm1 varchar (1)   as
select PJCOMMUN.*, RECEIPT.*, SENDER.*
	from PJCOMMUN
		left outer join  PJEMPLOY SENDER
			on PJCOMMUN.sender = SENDER.employee
		, PJEMPLOY RECEIPT
	where PJCOMMUN.destination = RECEIPT.employee
		and PJCOMMUN.msg_status = @parm1
		and RECEIPT.em_id03 <> ''
		and (RECEIPT.em_id06 = 1 OR RECEIPT.em_id06 = 2)
	order by PJCOMMUN.destination,
		PJCOMMUN.msg_status,
		PJCOMMUN.crtd_datetime
GO
