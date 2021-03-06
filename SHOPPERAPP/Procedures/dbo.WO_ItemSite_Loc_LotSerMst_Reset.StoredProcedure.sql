USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[WO_ItemSite_Loc_LotSerMst_Reset]    Script Date: 12/21/2015 16:13:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[WO_ItemSite_Loc_LotSerMst_Reset]
   @ProgID        varchar (8),
   @UserID        varchar (10),
   @ErrorCode     smallint OUTPUT
as
   set nocount on

   Update ItemSite
   Set QtyWOFirmSupply = 0,
       QtyWORlsedSupply = 0,
       QtyWOFirmDemand = 0,
       QtyWORlsedDemand = 0

	if (@@error = 0)
		print 'ItemSite Reset complete'
	else
		begin
			print 'ItemSite Reset error'
			select @ErrorCode = 1
			goto FINISH
		end

   Update Location
   Set QtyWORlsedDemand = 0
	if (@@error = 0)
		print 'Location Reset complete'
	else
		begin
			print 'Location Reset error'
			select @ErrorCode = 2
			goto FINISH
		end

   Update LotSerMst
   Set QtyWORlsedDemand = 0
	if (@@error = 0)
		print 'LotSerMst Reset complete'
	else
		begin
			print 'LotSerMst Reset error'
			select @ErrorCode = 2
			goto FINISH
		end

FINISH:
GO
