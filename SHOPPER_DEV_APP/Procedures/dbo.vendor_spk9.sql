USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[vendor_spk9]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[vendor_spk9] @parm1 varchar (250) , @parm2 varchar (15)  as
select * from  vendor
where vendid = @parm2
order by vendid
GO
