USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBILLSB_spk0]    Script Date: 12/21/2015 16:07:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBILLSB_spk0] @parm1 varchar (16) , @parm2 varchar (15)   as
select * from PJBILLSB, CUSTOMER
where project =  @parm1 and
pjbillsb.customer like  @parm2 and
pjbillsb.customer = customer.custid
order by project, customer
GO
