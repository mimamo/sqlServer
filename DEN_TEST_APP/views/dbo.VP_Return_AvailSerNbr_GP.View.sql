USE [DEN_TEST_APP]
GO
/****** Object:  View [dbo].[VP_Return_AvailSerNbr_GP]    Script Date: 12/21/2015 14:10:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[VP_Return_AvailSerNbr_GP] 
AS 
	SELECT *  
	FROM LotSerMst M 
	WHERE ---*** Filter out Serial Nbr which are on Transfer..............
		M.LotSerNbr Not In (Select T.LotSerNbr 
							From LotSerT T 
							Where T.TranType = 'TR' 
								and T.BatNbr In (Select R.BatNbr 
												From trnsfrdoc R,Batch B
												Where R.BatNbr = B.BatNbr 
													and B.BatType = 'N'
													and B.Rlsed = 1 
													And R.transfertype = 2
													AND R.S4Future11 = ''
													AND R.RcptNbr = '' 
												) 
								AND M.InvtID = T.InvtID
								AND M.SiteId = T.SiteId
								AND M.WhseLoc = T.WhseLoc
								) --***End Of Transfer Filter

		   ---*** Section Added to Filterout Serial that are already on Return..........
		   AND M.LotSerNbr Not In (Select T.LotSerNbr 
									From LotSerT T 
									Where T.TranType = 'RI' 
										and T.BatNbr in (Select I.BatNbr 
														From InTran I,Batch B 
														Where  I.BatNbr = B.BatNbr    
															and B.BatType = 'N'
															and B.Rlsed = 0    
															and I.TranType = 'RI'
														) 
										AND M.InvtID = T.InvtID
										AND M.SiteId = T.SiteId
										AND M.WhseLoc = T.WhseLoc
									)   ---***End Return  Filter...
		   AND Status = 'H'
		   AND QtyOnHand = 0
		   GROUP BY InvtId, SiteID, WhseLoc, LotSerNbr,RcptDate,ExpDate,LIFODate,
					Cost,Crtd_DateTime,Crtd_Prog,Crtd_User,LUpd_DateTime,LUpd_Prog,LUpd_User,MfgrLotSerNbr,NoteID,OrigQty,
					QtyOnHand,QtyAlloc,QtyAllocBM,QtyAllocIN,QtyAllocOther,QtyAllocPORet,QtyAllocSD,QtyAlloc,QtyAllocSO,QtyAvail,
					QtyShipNotInv,QtyWORlsedDemand,S4Future01,S4Future02,S4Future03,S4Future04,S4Future05,S4Future06,
					S4Future07,S4Future08,S4Future09,S4Future10,S4Future11,S4Future12,ShipContCode,Source,
					SrcOrdNbr,Status,StatusDate,User1,User2,User3,User4,User5,User6,User7,User8,WarrantyDate,Tstamp
GO
