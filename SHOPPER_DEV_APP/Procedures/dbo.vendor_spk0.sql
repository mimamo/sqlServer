USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[vendor_spk0]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[vendor_spk0] @parm1 varchar (15)  as
select * from  vendor
where vendid = @parm1
order by vendid
GO
