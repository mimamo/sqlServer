USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOMDET_spta]    Script Date: 12/21/2015 13:44:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCOMDET_spta] @parm1 varchar (16) , @parm2 varchar (32) , @parm3 varchar (16)   as
select  PJCOMDET.*,  VENDOR.*,  INVENTORY.descr
	from PJCOMDET
		left outer join VENDOR
			on PJCOMDET.vendor_num = VENDOR.vendid
		left outer join INVENTORY
			on PJCOMDET.part_number = INVENTORY.invtid
	where PJCOMDET.project =  @parm1 and
		PJCOMDET.pjt_entity  like  @parm2 and
		PJCOMDET.acct like @parm3
	order by po_date, purchase_order_num, cd_id04, part_number
GO
