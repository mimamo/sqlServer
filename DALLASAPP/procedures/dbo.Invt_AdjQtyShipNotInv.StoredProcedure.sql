USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[Invt_AdjQtyShipNotInv]    Script Date: 12/21/2015 13:44:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Invt_AdjQtyShipNotInv]  
	 @InvtID   varchar(30),  
	 @SiteID   varchar(10),  
	 @WhseLoc  varchar(10),  
	 @LotSerNbr  varchar(25),   
	 @QtyShip  float,  
	 @ProgID   varchar(8),  
	 @UserID   varchar(10)
as  
 set nocount on  
  
 declare @QtyPrec smallint  
 declare @StkItem smallint  
  
 -- Exit if no quantity is being adjusted.  
 if (@QtyShip = 0)  
	return  
  
 -- Fetch information from Inventory.  
 select @StkItem = StkItem  
	from Inventory (nolock)  
	where InvtID = @InvtID  
  
 -- Exit if the item is not a stock item.  
 if (@StkItem = 0)  
	return  
	
 -- Get the precision.  
 select @QtyPrec = (select DecPlQty from INSetup (nolock))  
  
 -- LotSerMst  
 if (rtrim(@LotSerNbr) > '')  
 begin  
	update LotSerMst  
	set S4Future06 = round((S4Future06 + @QtyShip), @QtyPrec),
		LUpd_DateTime = GetDate(),  
		LUpd_Prog = @ProgID,  
		LUpd_User = @UserID  
	where InvtID = @InvtID  
		and SiteID = @SiteID  
		and  WhseLoc = @WhseLoc  
		and LotSerNbr = @LotSerNbr  
 end  
  
 -- Location  
 update Location  
 set S4Future06 = round((S4Future06 + @QtyShip), @QtyPrec),  
	LUpd_DateTime = GetDate(),  
	LUpd_Prog = @ProgID,  
	LUpd_User = @UserID  
	where InvtID = @InvtID  
		and SiteID = @SiteID  
		and  WhseLoc = @WhseLoc
GO
