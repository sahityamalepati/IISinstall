{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "vmPassword": {
            "type": "securestring"
        },
        "sqlPassword": {
            "type": "securestring"
        }
    },
    "functions": [],
    "variables": {
        "primNSG": "primNSG",
        "secNSG": "secNSG",
        "primVM1": "primVM1",
        "primVM2": "primVM2",
        "secVM1": "secVM1",
        "secVM2": "secVM2",
        "jumpVM1": "jumpVM1",
        "jumpVM2": "jumpVM2",
        "primPIP": "primPIP",
        "secPIP": "secPIP",
        "vm1Size": "Standard_A2_v2",
        "vm2Size": "Standard_A2_v2",
        "jumpVMSize": "Standard_D2_v3",
        "lb1": "lb1",
        "lb2": "lb2",
        "primStorage1": "guestdiagstorereadiness",
        "primStorage2": "bootdiagstorereadiness",
        "primLocation": "Southeast Asia",
        "secLocation": "Australia East",
        "primVnet": "prod-vnet",
        "secVnet": "dr-vnet",
        "lb1dns": "primlbinfrareadiness",
        "lb2dns": "seclbinfrareadiness",
        "lb1outdns": "primlboutinfrareadiness",
        "lb2outdns": "seclboutinfrareadiness",
        "tmName": "globalLB",
        "tmDNS": "globalLBReadiness",
        "primSQLServer": "primsqlserverreadiness",
        "secSQLServer": "secsqlserverreadiness",
        "sqlFailoverGroupName": "infra-readiness-fg-dbserver",
        "primPEName": "primPE",
        "secPEName": "secPE",
        "privateDNSZoneName": "[concat('privatelink' , environment().suffixes.sqlServerHostname)]",
        "primDNSGroup": "primDNSGroup",
        "secDNSGroup": "secDNSGRoup",
        "primDNSGroupName": "[concat(variables('primPEName'),'/', variables('primDNSGroup'))]",
        "secDNSGroupName": "[concat(variables('secPEName'),'/',variables('secDNSGroup'))]",
        "primOutPIP": "primOutPIP",
        "secOUtPIP": "secOutPIP",
        "accountid": "[resourceId('Microsoft.Storage/storageAccounts/', variables('primStorage2'))]",
        "wadlogs": "<WadCfg> <DiagnosticMonitorConfiguration overallQuotaInMB=\"4096\" xmlns=\"http://schemas.microsoft.com/ServiceHosting/2010/10/DiagnosticsConfiguration\"> <DiagnosticInfrastructureLogs scheduledTransferLogLevelFilter=\"Error\"/> <WindowsEventLog scheduledTransferPeriod=\"PT1M\" > <DataSource name=\"Application!*[System[(Level = 1 or Level = 2)]]\" /> <DataSource name=\"Security!*[System[(Level = 1 or Level = 2)]]\" /> <DataSource name=\"System!*[System[(Level = 1 or Level = 2)]]\" /></WindowsEventLog>",
        "wadperfcounters1": "<PerformanceCounters scheduledTransferPeriod=\"PT1M\"><PerformanceCounterConfiguration counterSpecifier=\"\\Processor(_Total)\\% Processor Time\" sampleRate=\"PT15S\" unit=\"Percent\"><annotation displayName=\"CPU utilization\" locale=\"en-us\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\"\\Processor(_Total)\\% Privileged Time\" sampleRate=\"PT15S\" unit=\"Percent\"><annotation displayName=\"CPU privileged time\" locale=\"en-us\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\"\\Processor(_Total)\\% User Time\" sampleRate=\"PT15S\" unit=\"Percent\"><annotation displayName=\"CPU user time\" locale=\"en-us\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\"\\Processor Information(_Total)\\Processor Frequency\" sampleRate=\"PT15S\" unit=\"Count\"><annotation displayName=\"CPU frequency\" locale=\"en-us\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\"\\System\\Processes\" sampleRate=\"PT15S\" unit=\"Count\"><annotation displayName=\"Processes\" locale=\"en-us\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\"\\Process(_Total)\\Thread Count\" sampleRate=\"PT15S\" unit=\"Count\"><annotation displayName=\"Threads\" locale=\"en-us\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\"\\Process(_Total)\\Handle Count\" sampleRate=\"PT15S\" unit=\"Count\"><annotation displayName=\"Handles\" locale=\"en-us\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\"\\Memory\\% Committed Bytes In Use\" sampleRate=\"PT15S\" unit=\"Percent\"><annotation displayName=\"Memory usage\" locale=\"en-us\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\"\\Memory\\Available Bytes\" sampleRate=\"PT15S\" unit=\"Bytes\"><annotation displayName=\"Memory available\" locale=\"en-us\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\"\\Memory\\Committed Bytes\" sampleRate=\"PT15S\" unit=\"Bytes\"><annotation displayName=\"Memory committed\" locale=\"en-us\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\"\\Memory\\Commit Limit\" sampleRate=\"PT15S\" unit=\"Bytes\"><annotation displayName=\"Memory commit limit\" locale=\"en-us\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\"\\PhysicalDisk(_Total)\\% Disk Time\" sampleRate=\"PT15S\" unit=\"Percent\"><annotation displayName=\"Disk active time\" locale=\"en-us\"/></PerformanceCounterConfiguration>",
        "wadperfcounters2": "<PerformanceCounterConfiguration counterSpecifier=\"\\PhysicalDisk(_Total)\\% Disk Read Time\" sampleRate=\"PT15S\" unit=\"Percent\"><annotation displayName=\"Disk active read time\" locale=\"en-us\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\"\\PhysicalDisk(_Total)\\% Disk Write Time\" sampleRate=\"PT15S\" unit=\"Percent\"><annotation displayName=\"Disk active write time\" locale=\"en-us\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\"\\PhysicalDisk(_Total)\\Disk Transfers/sec\" sampleRate=\"PT15S\" unit=\"CountPerSecond\"><annotation displayName=\"Disk operations\" locale=\"en-us\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\"\\PhysicalDisk(_Total)\\Disk Reads/sec\" sampleRate=\"PT15S\" unit=\"CountPerSecond\"><annotation displayName=\"Disk read operations\" locale=\"en-us\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\"\\PhysicalDisk(_Total)\\Disk Writes/sec\" sampleRate=\"PT15S\" unit=\"CountPerSecond\"><annotation displayName=\"Disk write operations\" locale=\"en-us\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\"\\PhysicalDisk(_Total)\\Disk Bytes/sec\" sampleRate=\"PT15S\" unit=\"BytesPerSecond\"><annotation displayName=\"Disk speed\" locale=\"en-us\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\"\\PhysicalDisk(_Total)\\Disk Read Bytes/sec\" sampleRate=\"PT15S\" unit=\"BytesPerSecond\"><annotation displayName=\"Disk read speed\" locale=\"en-us\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\"\\PhysicalDisk(_Total)\\Disk Write Bytes/sec\" sampleRate=\"PT15S\" unit=\"BytesPerSecond\"><annotation displayName=\"Disk write speed\" locale=\"en-us\"/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\"\\LogicalDisk(_Total)\\% Free Space\" sampleRate=\"PT15S\" unit=\"Percent\"><annotation displayName=\"Disk free space (percentage)\" locale=\"en-us\"/></PerformanceCounterConfiguration></PerformanceCounters>",
        "wadcfgxstart": "[concat(variables('wadlogs'), variables('wadperfcounters1'), variables('wadperfcounters2'), '<Metrics resourceId=\"')]",
        "wadmetricsresourceidPrimVM1": "[resourceId('Microsoft.Compute/virtualMachines', variables('primVM1'))]",
        "wadmetricsresourceidPrimVM2": "[resourceId('Microsoft.Compute/virtualMachines', variables('primVM2'))]",
        "wadmetricsresourceidSecVM1": "[resourceId('Microsoft.Compute/virtualMachines', variables('secVM1'))]",
        "wadmetricsresourceidSecVM2": "[resourceId('Microsoft.Compute/virtualMachines', variables('secVM2'))]",
        "wadcfgxend": "\"><MetricAggregation scheduledTransferPeriod=\"PT1H\"/><MetricAggregation scheduledTransferPeriod=\"PT1M\"/></Metrics></DiagnosticMonitorConfiguration></WadCfg>",
        "primWSName": "[concat('primworkspace', uniqueString(subscription().subscriptionId))]",
        "secWSName": "[concat('secworkspace', uniqueString(subscription().subscriptionId))]",
        "daExtensionName": "DependencyAgentWindows",
        "daExtensionType": "DependencyAgentWindows",
        "daExtensionVersion": "9.5",
        "mmaExtensionName": "MMAExtension",
        "mmaExtensionType": "MicrosoftMonitoringAgent",
        "mmaExtensionVersion": "1.0",
        "dbName": "DotNetAppSqlDb_db"
    },
    "resources": [
        {
            "name": "[variables('primVnet')]",
            "type": "Microsoft.Network/virtualNetworks",
            "apiVersion": "2019-11-01",
            "location": "[variables('primLocation')]",
            "dependsOn": [ "[resourceId('Microsoft.Network/networkSecurityGroups/', variables('primNSG'))]" ],
            "properties": {
                "addressSpace": {
                    "addressPrefixes": [
                        "10.200.0.0/24"
                    ]
                },
                "subnets": [
                    {
                        "name": "jumpSubnet",
                        "properties": {
                            "addressPrefix": "10.200.0.0/28",
                            "networkSecurityGroup": {
                                "id": "[resourceId('Microsoft.Network/networkSecurityGroups/',variables('primNSG'))]"
                            }
                        }
                    },
                    {
                        "name": "vmSubnet",
                        "properties": {
                            "addressPrefix": "10.200.0.16/28",
                            "networkSecurityGroup": {
                                "id": "[resourceId('Microsoft.Network/networkSecurityGroups/',variables('primNSG'))]"
                            },
                            "privateEndpointNetworkPolicies": "Disabled"
                        }
                    }
                ]
            },
            "resources": [
                {
                    "apiVersion": "2020-05-01",
                    "type": "virtualNetworkPeerings",
                    "name": "vnet1-vnet2-peering",
                    "location": "[variables('primLocation')]",
                    "dependsOn": [
                        "[resourceId('Microsoft.Network/virtualNetworks/', variables('primVnet'))]",
                        "[resourceId('Microsoft.Network/virtualNetworks/', variables('secVnet'))]"
                    ],
                    "comments": "This is the peering from vNet 1 to vNet 2",
                    "properties": {
                        "allowVirtualNetworkAccess": true,
                        "allowForwardedTraffic": false,
                        "allowGatewayTransit": false,
                        "useRemoteGateways": false,
                        "remoteVirtualNetwork": {
                            "id": "[resourceId('Microsoft.Network/virtualNetworks',variables('secVnet'))]"
                        }
                    }
                }
            ]
        },
        {
            "name": "[variables('secVnet')]",
            "type": "Microsoft.Network/virtualNetworks",
            "apiVersion": "2019-11-01",
            "location": "[variables('secLocation')]",
            "dependsOn": [
                "[resourceId('Microsoft.Network/networkSecurityGroups/',variables('secNSG'))]"
            ],
            "properties": {
                "addressSpace": {
                    "addressPrefixes": [
                        "10.100.0.0/24"
                    ]
                },
                "subnets": [
                    {
                        "name": "jumpSubnet",
                        "properties": {
                            "addressPrefix": "10.100.0.0/28",
                            "networkSecurityGroup": {
                                "id": "[resourceId('Microsoft.Network/networkSecurityGroups/',variables('secNSG'))]"
                            }
                        }
                    },
                    {
                        "name": "vmSubnet",
                        "properties": {
                            "addressPrefix": "10.100.0.16/28",
                            "networkSecurityGroup": {
                                "id": "[resourceId('Microsoft.Network/networkSecurityGroups/',variables('secNSG'))]"
                            },
                            "privateEndpointNetworkPolicies": "Disabled"
                        }
                    }
                ]
            },
            "resources": [
                {
                    "apiVersion": "2020-05-01",
                    "type": "virtualNetworkPeerings",
                    "name": "vnet2-vnet1-peering",
                    "location": "[variables('secLocation')]",
                    "dependsOn": [
                        "[resourceId('Microsoft.Network/virtualNetworks/', variables('primVnet'))]",
                        "[resourceId('Microsoft.Network/virtualNetworks/', variables('secVnet'))]"
                    ],
                    "comments": "This is the peering from vNet 2 to vNet 1",
                    "properties": {
                        "allowVirtualNetworkAccess": true,
                        "allowForwardedTraffic": false,
                        "allowGatewayTransit": false,
                        "useRemoteGateways": false,
                        "remoteVirtualNetwork": {
                            "id": "[resourceId('Microsoft.Network/virtualNetworks',variables('primVnet'))]"
                        }
                    }
                }
            ]
        },
        {
            "name": "[variables('primStorage1')]",
            "type": "Microsoft.Storage/storageAccounts",
            "apiVersion": "2019-06-01",
            "location": "[variables('primLocation')]",
            "kind": "StorageV2",
            "sku": {
                "name": "Standard_GRS",
                "tier": "Standard"
            }
        },
        {
            "name": "[variables('primStorage2')]",
            "type": "Microsoft.Storage/storageAccounts",
            "apiVersion": "2019-06-01",
            "location": "[variables('primLocation')]",
            "kind": "StorageV2",
            "sku": {
                "name": "Standard_GRS",
                "tier": "Standard"
            }
        },
        {
            "name": "[variables('primPIP')]",
            "type": "Microsoft.Network/publicIPAddresses",
            "sku": {
                "name": "Standard"
            },
            "apiVersion": "2019-11-01",
            "location": "[variables('primLocation')]",
            "properties": {
                "publicIPAllocationMethod": "Static",
                "dnsSettings": {
                    "domainNameLabel": "[variables('lb1dns')]"
                }
            }
        },
        {
            "name": "[variables('secPIP')]",
            "type": "Microsoft.Network/publicIPAddresses",
            "sku": {
                "name": "Standard"
            },
            "apiVersion": "2019-11-01",
            "location": "[variables('secLocation')]",
            "properties": {
                "publicIPAllocationMethod": "Static",
                "dnsSettings": {
                    "domainNameLabel": "[variables('lb2dns')]"
                }
            }
        },
        {
            "name": "[variables('primOutPIP')]",
            "type": "Microsoft.Network/publicIPAddresses",
            "sku": {
                "name": "Standard"
            },
            "apiVersion": "2019-11-01",
            "location": "[variables('primLocation')]",
            "properties": {
                "publicIPAllocationMethod": "Static",
                "dnsSettings": {
                    "domainNameLabel": "[variables('lb1outdns')]"
                }
            }
        },
        {
            "name": "[variables('secOutPIP')]",
            "type": "Microsoft.Network/publicIPAddresses",
            "sku": {
                "name": "Standard"
            },
            "apiVersion": "2019-11-01",
            "location": "[variables('secLocation')]",
            "properties": {
                "publicIPAllocationMethod": "Static",
                "dnsSettings": {
                    "domainNameLabel": "[variables('lb2outdns')]"
                }
            }
        },
        {
            "name": "[variables('lb1')]",
            "sku": {
                "name": "Standard"
            },
            "type": "Microsoft.Network/loadBalancers",
            "apiVersion": "2019-11-01",
            "location": "[variables('primLocation')]",
            "dependsOn": [
                "[resourceId('Microsoft.Network/publicIPAddresses', variables('primPIP'))]",
                "[resourceId('Microsoft.Network/publicIPAddresses', variables('primOutPIP'))]"
            ],
            "properties": {
                "frontendIPConfigurations": [
                    {
                        "name": "loadBalancerFrontEnd1",
                        "properties": {
                            "publicIPAddress": {
                                "id": "[resourceId('Microsoft.Network/publicIPAddresses', variables('primPIP'))]"
                            }
                        }
                    },
                    {

                        "name": "loadBalancerFrontend2",
                        "properties": {
                            "publicIPAddress": {
                                "id": "[resourceId('Microsoft.Network/publicIPAddresses', variables('primOutPIP'))]"
                            }
                        }
                    }
                ],
                "backendAddressPools": [
                    {
                        "name": "loadBalancerBackEndPoolInbound"
                    },
                    {
                        "name": "loadBalancerBackendPoolOutbound"
                    }
                ],
                "loadBalancingRules": [
                    {
                        "name": "LBRule1",
                        "properties": {
                            "frontendIPConfiguration": {
                                "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', variables('lb1'), 'loadBalancerFrontEnd1')]"
                            },
                            "backendAddressPool": {
                                "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', variables('lb1'), 'loadBalancerBackEndPoolInbound')]"
                            },
                            "protocol": "Tcp",
                            "frontendPort": 80,
                            "backendPort": 80,
                            "enableFloatingIP": false,
                            "idleTimeoutInMinutes": 5,
                            "disableOutboundSnat": true,
                            "probe": {
                                "id": "[resourceId('Microsoft.Network/loadBalancers/probes', variables('lb1'), 'httpProbe')]"
                            }
                        }
                    }
                ],
                "inboundNatRules": [
                    {
                        "name": "[concat(variables('jumpVM1'),'-RDP-NAT')]",
                        "properties": {
                            "frontendIPConfiguration": {
                                "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', variables('lb1'), 'loadBalancerFrontEnd1')]"
                            },
                            "protocol": "Tcp",
                            "frontendPort": 4000,
                            "backendPort": 3389,
                            "enableFloatingIP": false
                        }
                    }
                ],
                "probes": [
                    {
                        "name": "httpProbe",
                        "properties": {
                            "protocol": "Http",
                            "port": 80,
                            "requestPath": "/",
                            "intervalInSeconds": 5,
                            "numberOfProbes": 2
                        }
                    }
                ],
                "outboundRules": [
                    {
                        "name": "OutboundTrafficRule",
                        "properties": {
                            "allocatedOutboundPorts": 10000,
                            "backendAddressPool": {
                                "id": "[resourceId('Microsoft.Network/loadBalancers/BackendAddressPools', variables('lb1'), 'loadBalancerBackendPoolOutbound')]"
                            },
                            "enableTcpReset": false,
                            "idleTimeoutInMinutes": 15,
                            "frontendIPConfigurations": [
                                {
                                    "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', variables('lb1'), 'loadBalancerFrontend2')]"
                                }
                            ],
                            "protocol": "All"
                        }
                    }
                ]
            }
        },
        {
            "name": "[variables('lb2')]",
            "type": "Microsoft.Network/loadBalancers",
            "sku": {
                "name": "Standard"
            },
            "apiVersion": "2019-11-01",
            "location": "[variables('secLocation')]",
            "dependsOn": [
                "[resourceId('Microsoft.Network/publicIPAddresses', variables('secPIP'))]",
                "[resourceId('Microsoft.Network/publicIPAddresses',variables('secOUtPIP'))]"
            ],
            "properties": {
                "frontendIPConfigurations": [
                    {
                        "name": "loadBalancerFrontEnd1",
                        "properties": {
                            "publicIPAddress": {
                                "id": "[resourceId('Microsoft.Network/publicIPAddresses', variables('secPIP'))]"
                            }
                        }
                    },
                    {
                        "name": "loadBalancerFrontend2",
                        "properties": {
                            "publicIPAddress": {
                                "id": "[resourceId('Microsoft.Network/publicIPAddresses',variables('secOUtPIP'))]"
                            }
                        }
                    }
                ],
                "backendAddressPools": [
                    {
                        "name": "loadBalancerBackEndPoolInbound"
                    },
                    {
                        "name": "loadBalancerBackendPoolOutbound"
                    }
                ],
                "loadBalancingRules": [
                    {
                        "name": "LBRule1",
                        "properties": {
                            "frontendIPConfiguration": {
                                "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', variables('lb2'), 'loadBalancerFrontEnd1')]"
                            },
                            "backendAddressPool": {
                                "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', variables('lb2'), 'loadBalancerBackEndPoolInbound')]"
                            },
                            "protocol": "Tcp",
                            "frontendPort": 80,
                            "backendPort": 80,
                            "enableFloatingIP": false,
                            "idleTimeoutInMinutes": 5,
                            "probe": {
                                "id": "[resourceId('Microsoft.Network/loadBalancers/probes', variables('lb2'), 'httpProbe')]"
                            },
                            "disableOutboundSnat": true
                        }
                    }
                ],
                "inboundNatRules": [
                    {
                        "name": "[concat(variables('jumpVM2'),'-RDP-NAT')]",
                        "properties": {
                            "frontendIPConfiguration": {
                                "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', variables('lb2'), 'loadBalancerFrontEnd1')]"
                            },
                            "protocol": "Tcp",
                            "frontendPort": 4000,
                            "backendPort": 3389,
                            "enableFloatingIP": false
                        }
                    }
                ],
                "probes": [
                    {
                        "name": "httpProbe",
                        "properties": {
                            "protocol": "Http",
                            "port": 80,
                            "requestPath": "/",
                            "intervalInSeconds": 5,
                            "numberOfProbes": 2
                        }
                    }
                ],
                "outboundRules": [
                    {
                        "name": "OutboundTrafficRule",
                        "properties": {
                            "allocatedOutboundPorts": 10000,
                            "backendAddressPool": {
                                "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', variables('lb2'), 'loadBalancerBackendPoolOutbound')]"
                            },
                            "enableTcpReset": false,
                            "idleTimeoutInMinutes": 15,
                            "frontendIPConfigurations": [
                                {
                                    "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', variables('lb2'),'loadBalancerFrontend2')]"
                                }
                            ],
                            "protocol": "All"
                        }
                    }
                ]
            }
        },
        {
            "name": "[variables('primNSG')]",
            "type": "Microsoft.Network/networkSecurityGroups",
            "apiVersion": "2018-08-01",
            "location": "[variables('primLocation')]",
            "properties": {
                "securityRules": [
                    {
                        "name": "allow_rdp_to_bastion",
                        "properties": {
                            "description": "RDP access to Bastion",
                            "protocol": "Tcp",
                            "sourcePortRange": "*",
                            "destinationPortRange": "3389",
                            "sourceAddressPrefix": "*",
                            "destinationAddressPrefix": "10.200.0.0/28",
                            "access": "Allow",
                            "priority": 1000,
                            "direction": "Inbound"
                        }
                    },
                    {
                        "name": "allow_web",
                        "properties": {
                            "description": "Allow web access",
                            "protocol": "Tcp",
                            "sourcePortRange": "*",
                            "destinationPortRange": "80",
                            "sourceAddressPrefix": "Internet",
                            "destinationAddressPrefix": "10.200.0.16/28",
                            "access": "Allow",
                            "priority": 2000,
                            "direction": "Inbound"
                        }
                    }
                ]
            }
        },
        {
            "name": "[variables('secNSG')]",
            "type": "Microsoft.Network/networkSecurityGroups",
            "apiVersion": "2019-11-01",
            "location": "[variables('secLocation')]",
            "properties": {
                "securityRules": [
                    {
                        "name": "allow_rdp_to_bastion",
                        "properties": {
                            "description": "RDP access to Bastion",
                            "protocol": "Tcp",
                            "sourcePortRange": "*",
                            "destinationPortRange": "3389",
                            "sourceAddressPrefix": "*",
                            "destinationAddressPrefix": "10.100.0.0/28",
                            "access": "Allow",
                            "priority": 1000,
                            "direction": "Inbound"
                        }
                    },
                    {
                        "name": "allow_web",
                        "properties": {
                            "description": "Allow web access",
                            "protocol": "Tcp",
                            "sourcePortRange": "*",
                            "destinationPortRange": "80",
                            "sourceAddressPrefix": "Internet",
                            "destinationAddressPrefix": "10.100.0.16/28",
                            "access": "Allow",
                            "priority": 2000,
                            "direction": "Inbound"
                        }
                    }
                ]
            }
        },
        {
            "name": "[concat(variables('primVM1'), '-NIC')]",
            "type": "Microsoft.Network/networkInterfaces",
            "apiVersion": "2019-11-01",
            "location": "[variables('primLocation')]",
            "dependsOn": [
                "[resourceId('Microsoft.Network/virtualNetworks', variables('primVnet'))]",
                "[resourceId('Microsoft.Network/loadBalancers',variables('lb1'))]"
            ],
            "properties": {
                "ipConfigurations": [
                    {
                        "name": "ipConfig1",
                        "properties": {
                            "privateIPAllocationMethod": "Dynamic",
                            "subnet": {
                                "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', variables('primVnet'), 'vmSubnet')]"
                            },
                            "loadBalancerBackendAddressPools": [
                                {
                                    "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools',variables('lb1'), 'loadBalancerBackEndPoolInbound')]"
                                },
                                {
                                    "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools',variables('lb1'),'loadBalancerBackendPoolOutbound')]"
                                }
                            ]
                        }
                    }
                ]
            }
        },
        {
            "name": "[concat(variables('primVM2'), '-NIC')]",
            "type": "Microsoft.Network/networkInterfaces",
            "apiVersion": "2019-11-01",
            "location": "[variables('primLocation')]",
            "dependsOn": [
                "[resourceId('Microsoft.Network/virtualNetworks', variables('primVnet'))]",
                "[resourceId('Microsoft.Network/loadBalancers',variables('lb1'))]"
            ],
            "properties": {
                "ipConfigurations": [
                    {
                        "name": "ipConfig1",
                        "properties": {
                            "privateIPAllocationMethod": "Dynamic",
                            "subnet": {
                                "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', variables('primVnet'), 'vmSubnet')]"
                            },
                            "loadBalancerBackendAddressPools": [
                                {
                                    "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools',variables('lb1'),'loadBalancerBackEndPoolInbound')]"
                                },
                                {
                                    "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools',variables('lb1'),'loadBalancerBackendPoolOutbound')]"
                                }
                            ]
                        }
                    }
                ]
            }
        },
        {
            "name": "[concat(variables('secVM1'), '-NIC')]",
            "type": "Microsoft.Network/networkInterfaces",
            "apiVersion": "2019-11-01",
            "location": "[variables('secLocation')]",
            "dependsOn": [
                "[resourceId('Microsoft.Network/virtualNetworks', variables('secVnet'))]",
                "[resourceId('Microsoft.Network/loadBalancers',variables('lb2'))]"
            ],
            "properties": {
                "ipConfigurations": [
                    {
                        "name": "ipConfig1",
                        "properties": {
                            "privateIPAllocationMethod": "Dynamic",
                            "subnet": {
                                "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', variables('secVnet'), 'vmSubnet')]"
                            },
                            "loadBalancerBackendAddressPools": [
                                {
                                    "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools',variables('lb2'),'loadBalancerBackEndPoolInbound')]"
                                },
                                {
                                    "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools',variables('lb2'),'loadBalancerBackendPoolOutbound')]"
                                }
                            ]
                        }
                    }
                ]
            }
        },
        {
            "name": "[concat(variables('secVM2'), '-NIC')]",
            "type": "Microsoft.Network/networkInterfaces",
            "apiVersion": "2019-11-01",
            "location": "[variables('secLocation')]",
            "dependsOn": [
                "[resourceId('Microsoft.Network/virtualNetworks', variables('secVnet'))]",
                "[resourceId('Microsoft.Network/loadBalancers',variables('lb2'))]"
            ],
            "properties": {
                "ipConfigurations": [
                    {
                        "name": "ipConfig1",
                        "properties": {
                            "privateIPAllocationMethod": "Dynamic",
                            "subnet": {
                                "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', variables('secVnet'), 'vmSubnet')]"
                            },
                            "loadBalancerBackendAddressPools": [
                                {
                                    "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools',variables('lb2'),'loadBalancerBackEndPoolInbound')]"
                                },
                                {
                                    "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools',variables('lb2'),'loadBalancerBackendPoolOutbound')]"
                                }
                            ]
                        }
                    }
                ]
            }
        },
        {
            "name": "[concat(variables('jumpVM1'), '-NIC')]",
            "type": "Microsoft.Network/networkInterfaces",
            "apiVersion": "2019-11-01",
            "location": "[variables('primLocation')]",
            "dependsOn": [
                "[resourceId('Microsoft.Network/virtualNetworks', variables('primVnet'))]",
                "[resourceId('Microsoft.Network/loadBalancers',variables('lb1'))]"
            ],
            "properties": {
                "ipConfigurations": [
                    {
                        "name": "ipConfig1",
                        "properties": {
                            "privateIPAllocationMethod": "Dynamic",
                            "subnet": {
                                "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', variables('primVnet'), 'jumpSubnet')]"
                            },
                            "loadBalancerInboundNatRules": [
                                {
                                    "id": "[resourceId('Microsoft.Network/loadBalancers/InboundNATRules',variables('lb1'),concat(variables('jumpVM1'),'-RDP-NAT'))]"
                                }
                            ],
                            "loadBalancerBackendAddressPools": [
                                {
                                    "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools',variables('lb1'),'loadBalancerBackendPoolOutbound')]"
                                }
                            ]
                        }
                    }
                ]
            }
        },
        {
            "name": "[concat(variables('jumpVM2'), '-NIC')]",
            "type": "Microsoft.Network/networkInterfaces",
            "apiVersion": "2019-11-01",
            "location": "[variables('secLocation')]",
            "dependsOn": [
                "[resourceId('Microsoft.Network/virtualNetworks', variables('secVnet'))]",
                "[resourceId('Microsoft.Network/loadBalancers',variables('lb2'))]"
            ],
            "properties": {
                "ipConfigurations": [
                    {
                        "name": "ipConfig1",
                        "properties": {
                            "privateIPAllocationMethod": "Dynamic",
                            "subnet": {
                                "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', variables('secVnet'), 'jumpSubnet')]"
                            },
                            "loadBalancerInboundNatRules": [
                                {
                                    "id": "[resourceId('Microsoft.Network/loadBalancers/InboundNATRules',variables('lb2'),concat(variables('jumpVM2'),'-RDP-NAT'))]"
                                }
                            ],
                            "loadBalancerBackendAddressPools": [
                                {
                                    "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools',variables('lb2'),'loadBalancerBackendPoolOutbound')]"
                                }
                            ]
                        }
                    }
                ]
            }
        },
        {
            "name": "[variables('primVM1')]",
            "type": "Microsoft.Compute/virtualMachines",
            "apiVersion": "2019-07-01",
            "zones": [ "1" ],
            "location": "[variables('primLocation')]",
            "dependsOn": [
                "[resourceId('Microsoft.Storage/storageAccounts', toLower(variables('primStorage1')))]",
                "[resourceId('Microsoft.Network/networkInterfaces', concat(variables('primVM1'),'-NIC'))]"
            ],
            "properties": {
                "hardwareProfile": {
                    "vmSize": "[variables('vm1Size')]"
                },
                "osProfile": {
                    "computerName": "[variables('primVM1')]",
                    "adminUsername": "azureuser",
                    "adminPassword": "[parameters('vmPassword')]"
                },
                "storageProfile": {
                    "imageReference": {
                        "publisher": "MicrosoftWindowsServer",
                        "offer": "WindowsServer",
                        "sku": "2016-Datacenter",
                        "version": "latest"
                    },
                    "osDisk": {
                        "name": "[concat(variables('primVM1'),'-OSDisk')]",
                        "caching": "ReadWrite",
                        "createOption": "FromImage"
                    }
                },
                "networkProfile": {
                    "networkInterfaces": [
                        {
                            "id": "[resourceId('Microsoft.Network/networkInterfaces', concat(variables('primVM1'),'-NIC'))]"
                        }
                    ]
                },
                "diagnosticsProfile": {
                    "bootDiagnostics": {
                        "enabled": true,
                        "storageUri": "[reference(resourceId('Microsoft.Storage/storageAccounts/', toLower(variables('primStorage1')))).primaryEndpoints.blob]"
                    }
                }
            },
            "resources": [
                {
                    "name": "Microsoft.Insights.VMDiagnosticsSettings",
                    "type": "extensions",
                    "location": "[variables('primLocation')]",
                    "apiVersion": "2020-06-01",
                    "dependsOn": [
                        "[resourceId('Microsoft.Compute/virtualMachines', variables('primVM1'))]"
                    ],
                    "properties": {
                        "publisher": "Microsoft.Azure.Diagnostics",
                        "type": "IaaSDiagnostics",
                        "typeHandlerVersion": "1.5",
                        "autoUpgradeMinorVersion": true,
                        "settings": {
                            "xmlCfg": "[base64(concat(variables('wadcfgxstart'), variables('wadmetricsresourceidPrimVM1'), variables('wadcfgxend')))]",
                            "storageAccount": "[variables('primStorage2')]"
                        },
                        "protectedSettings": {
                            "storageAccountName": "[variables('primStorage2')]",
                            "storageAccountKey": "[listkeys(variables('accountid'), '2019-06-01').keys[0].value]",
                            "storageAccountEndPoint": "[concat('https://', environment().suffixes.storage)]"
                        }
                    }
                }
            ]
        },
        {
            "name": "[variables('primVM2')]",
            "type": "Microsoft.Compute/virtualMachines",
            "apiVersion": "2019-07-01",
            "zones": [ "2" ],
            "location": "[variables('primLocation')]",
            "dependsOn": [
                "[resourceId('Microsoft.Storage/storageAccounts', toLower(variables('primStorage1')))]",
                "[resourceId('Microsoft.Network/networkInterfaces', concat(variables('primVM2'),'-NIC'))]"
            ],
            "properties": {
                "hardwareProfile": {
                    "vmSize": "[variables('vm2Size')]"
                },
                "osProfile": {
                    "computerName": "[variables('primVM2')]",
                    "adminUsername": "azureuser",
                    "adminPassword": "[parameters('vmPassword')]"
                },
                "storageProfile": {
                    "imageReference": {
                        "publisher": "MicrosoftWindowsServer",
                        "offer": "WindowsServer",
                        "sku": "2016-Datacenter",
                        "version": "latest"
                    },
                    "osDisk": {
                        "name": "[concat(variables('primVM2'),'-OSDisk')]",
                        "caching": "ReadWrite",
                        "createOption": "FromImage"
                    }
                },
                "networkProfile": {
                    "networkInterfaces": [
                        {
                            "id": "[resourceId('Microsoft.Network/networkInterfaces', concat(variables('primVM2'),'-NIC'))]"
                        }
                    ]
                },
                "diagnosticsProfile": {
                    "bootDiagnostics": {
                        "enabled": true,
                        "storageUri": "[reference(resourceId('Microsoft.Storage/storageAccounts/', toLower(variables('primStorage1')))).primaryEndpoints.blob]"
                    }
                }
            },
            "resources": [
                {
                    "name": "Microsoft.Insights.VMDiagnosticsSettings",
                    "type": "extensions",
                    "location": "[variables('primLocation')]",
                    "apiVersion": "2020-06-01",
                    "dependsOn": [
                        "[resourceId('Microsoft.Compute/virtualMachines', variables('primVM2'))]"
                    ],
                    "properties": {
                        "publisher": "Microsoft.Azure.Diagnostics",
                        "type": "IaaSDiagnostics",
                        "typeHandlerVersion": "1.5",
                        "autoUpgradeMinorVersion": true,
                        "settings": {
                            "xmlCfg": "[base64(concat(variables('wadcfgxstart'), variables('wadmetricsresourceidPrimVM2'), variables('wadcfgxend')))]",
                            "storageAccount": "[variables('primStorage2')]"
                        },
                        "protectedSettings": {
                            "storageAccountName": "[variables('primStorage2')]",
                            "storageAccountKey": "[listkeys(variables('accountid'), '2019-06-01').keys[0].value]",
                            "storageAccountEndPoint": "[concat('https://', environment().suffixes.storage)]"
                        }
                    }
                }
            ]
        },
        {
            "name": "[variables('secVM1')]",
            "type": "Microsoft.Compute/virtualMachines",
            "apiVersion": "2019-07-01",
            "zones": [ "1" ],
            "location": "[variables('secLocation')]",
            "dependsOn": [
                "[resourceId('Microsoft.Storage/storageAccounts', toLower(variables('primStorage1')))]",
                "[resourceId('Microsoft.Network/networkInterfaces', concat(variables('secVM1'),'-NIC'))]"
            ],
            "properties": {
                "hardwareProfile": {
                    "vmSize": "[variables('vm1Size')]"
                },
                "osProfile": {
                    "computerName": "[variables('secVM1')]",
                    "adminUsername": "azureuser",
                    "adminPassword": "[parameters('vmPassword')]"
                },
                "storageProfile": {
                    "imageReference": {
                        "publisher": "MicrosoftWindowsServer",
                        "offer": "WindowsServer",
                        "sku": "2016-Datacenter",
                        "version": "latest"
                    },
                    "osDisk": {
                        "name": "[concat(variables('secVM1'),'-OSDisk')]",
                        "caching": "ReadWrite",
                        "createOption": "FromImage"
                    }
                },
                "networkProfile": {
                    "networkInterfaces": [
                        {
                            "id": "[resourceId('Microsoft.Network/networkInterfaces', concat(variables('secVM1'),'-NIC'))]"
                        }
                    ]
                },
                "diagnosticsProfile": {
                    "bootDiagnostics": {
                        "enabled": true,
                        "storageUri": "[reference(resourceId('Microsoft.Storage/storageAccounts/', toLower(variables('primStorage1')))).primaryEndpoints.blob]"
                    }
                }
            },
            "resources": [
                {
                    "name": "Microsoft.Insights.VMDiagnosticsSettings",
                    "type": "extensions",
                    "location": "[variables('secLocation')]",
                    "apiVersion": "2020-06-01",
                    "dependsOn": [
                        "[resourceId('Microsoft.Compute/virtualMachines', variables('secVM1'))]"
                    ],
                    "properties": {
                        "publisher": "Microsoft.Azure.Diagnostics",
                        "type": "IaaSDiagnostics",
                        "typeHandlerVersion": "1.5",
                        "autoUpgradeMinorVersion": true,
                        "settings": {
                            "xmlCfg": "[base64(concat(variables('wadcfgxstart'), variables('wadmetricsresourceidSecVM1'), variables('wadcfgxend')))]",
                            "storageAccount": "[variables('primStorage2')]"
                        },
                        "protectedSettings": {
                            "storageAccountName": "[variables('primStorage2')]",
                            "storageAccountKey": "[listkeys(variables('accountid'), '2019-06-01').keys[0].value]",
                            "storageAccountEndPoint": "[concat('https://', environment().suffixes.storage)]"
                        }
                    }
                }
            ]
        },
        {
            "name": "[variables('secVM2')]",
            "type": "Microsoft.Compute/virtualMachines",
            "apiVersion": "2019-07-01",
            "zones": [ "2" ],
            "location": "[variables('secLocation')]",
            "dependsOn": [
                "[resourceId('Microsoft.Storage/storageAccounts', toLower(variables('primStorage1')))]",
                "[resourceId('Microsoft.Network/networkInterfaces', concat(variables('secVM2'),'-NIC'))]"
            ],
            "properties": {
                "hardwareProfile": {
                    "vmSize": "[variables('vm2Size')]"
                },
                "osProfile": {
                    "computerName": "[variables('secVM2')]",
                    "adminUsername": "azureuser",
                    "adminPassword": "[parameters('vmPassword')]"
                },
                "storageProfile": {
                    "imageReference": {
                        "publisher": "MicrosoftWindowsServer",
                        "offer": "WindowsServer",
                        "sku": "2016-Datacenter",
                        "version": "latest"
                    },
                    "osDisk": {
                        "name": "[concat(variables('secVM2'),'-OSDisk')]",
                        "caching": "ReadWrite",
                        "createOption": "FromImage"
                    }
                },
                "networkProfile": {
                    "networkInterfaces": [
                        {
                            "id": "[resourceId('Microsoft.Network/networkInterfaces', concat(variables('secVM2'),'-NIC'))]"
                        }
                    ]
                },
                "diagnosticsProfile": {
                    "bootDiagnostics": {
                        "enabled": true,
                        "storageUri": "[reference(resourceId('Microsoft.Storage/storageAccounts/', toLower(variables('primStorage1')))).primaryEndpoints.blob]"
                    }
                }
            },
            "resources": [
                {
                    "name": "Microsoft.Insights.VMDiagnosticsSettings",
                    "type": "extensions",
                    "location": "[variables('secLocation')]",
                    "apiVersion": "2020-06-01",
                    "dependsOn": [
                        "[resourceId('Microsoft.Compute/virtualMachines', variables('secVM2'))]"
                    ],
                    "properties": {
                        "publisher": "Microsoft.Azure.Diagnostics",
                        "type": "IaaSDiagnostics",
                        "typeHandlerVersion": "1.5",
                        "autoUpgradeMinorVersion": true,
                        "settings": {
                            "xmlCfg": "[base64(concat(variables('wadcfgxstart'), variables('wadmetricsresourceidSecVM2'), variables('wadcfgxend')))]",
                            "storageAccount": "[variables('primStorage2')]"
                        },
                        "protectedSettings": {
                            "storageAccountName": "[variables('primStorage2')]",
                            "storageAccountKey": "[listkeys(variables('accountid'), '2019-06-01').keys[0].value]",
                            "storageAccountEndPoint": "[concat('https://', environment().suffixes.storage)]"
                        }
                    }
                }
            ]
        },
        {
            "name": "[variables('jumpVM1')]",
            "type": "Microsoft.Compute/virtualMachines",
            "apiVersion": "2019-07-01",
            "location": "[variables('primLocation')]",
            "dependsOn": [
                "[resourceId('Microsoft.Storage/storageAccounts', toLower(variables('primStorage1')))]",
                "[resourceId('Microsoft.Network/networkInterfaces', concat(variables('jumpVM1'),'-NIC'))]"
            ],
            "properties": {
                "hardwareProfile": {
                    "vmSize": "[variables('jumpVMSize')]"
                },
                "osProfile": {
                    "computerName": "[variables('jumpVM1')]",
                    "adminUsername": "azureuser",
                    "adminPassword": "[parameters('vmPassword')]"
                },
                "storageProfile": {
                    "imageReference": {
                        "publisher": "microsoftvisualstudio",
                        "offer": "visualstudio2019latest",
                        "sku": "vs-2019-comm-latest-ws2019",
                        "version": "latest"
                    },
                    "osDisk": {
                        "name": "[concat(variables('jumpVM1'),'-OSDisk')]",
                        "caching": "ReadWrite",
                        "createOption": "FromImage"
                    }
                },
                "networkProfile": {
                    "networkInterfaces": [
                        {
                            "id": "[resourceId('Microsoft.Network/networkInterfaces', concat(variables('jumpVM1'),'-NIC'))]"
                        }
                    ]
                },
                "diagnosticsProfile": {
                    "bootDiagnostics": {
                        "enabled": true,
                        "storageUri": "[reference(resourceId('Microsoft.Storage/storageAccounts/', toLower(variables('primStorage1')))).primaryEndpoints.blob]"
                    }
                }
            }
        },
        {
            "name": "[variables('jumpVM2')]",
            "type": "Microsoft.Compute/virtualMachines",
            "apiVersion": "2019-07-01",
            "location": "[variables('secLocation')]",
            "dependsOn": [
                "[resourceId('Microsoft.Storage/storageAccounts', toLower(variables('primStorage1')))]",
                "[resourceId('Microsoft.Network/networkInterfaces', concat(variables('jumpVM2'),'-NIC'))]"
            ],
            "properties": {
                "hardwareProfile": {
                    "vmSize": "[variables('jumpVMSize')]"
                },
                "osProfile": {
                    "computerName": "[variables('jumpVM2')]",
                    "adminUsername": "azureuser",
                    "adminPassword": "[parameters('vmPassword')]"
                },
                "storageProfile": {
                    "imageReference": {
                        "publisher": "microsoftvisualstudio",
                        "offer": "visualstudio2019latest",
                        "sku": "vs-2019-comm-latest-ws2019",
                        "version": "latest"
                    },
                    "osDisk": {
                        "name": "[concat(variables('jumpVM2'),'-OSDisk')]",
                        "caching": "ReadWrite",
                        "createOption": "FromImage"
                    }
                },
                "networkProfile": {
                    "networkInterfaces": [
                        {
                            "id": "[resourceId('Microsoft.Network/networkInterfaces', concat(variables('jumpVM2'),'-NIC'))]"
                        }
                    ]
                },
                "diagnosticsProfile": {
                    "bootDiagnostics": {
                        "enabled": true,
                        "storageUri": "[reference(resourceId('Microsoft.Storage/storageAccounts/', toLower(variables('primStorage1')))).primaryEndpoints.blob]"
                    }
                }
            }
        },
        {
            "name": "[variables('tmName')]",
            "type": "Microsoft.Network/trafficManagerProfiles",
            "dependsOn": [
                "[resourceId('Microsoft.Network/publicIPAddresses',variables('primPIP'))]",
                "[resourceId('Microsoft.Network/publicIPAddresses', variables('secPIP'))]"
            ],
            "apiVersion": "2018-04-01",
            "location": "global",
            "properties": {
                "profileStatus": "Enabled",
                "trafficRoutingMethod": "Performance",
                "dnsConfig": {
                    "relativeName": "[variables('tmDNS')]",
                    "ttl": 30
                },
                "monitorConfig": {
                    "protocol": "HTTP",
                    "port": 80,
                    "path": "/",
                    "intervalInSeconds": 30,
                    "timeoutInSeconds": 5,
                    "toleratedNumberOfFailures": 3
                },
                "endpoints": [
                    {
                        "name": "Primary-Endpoint",
                        "type": "Microsoft.Network/trafficManagerProfiles/azureEndpoints",
                        "properties": {
                            "targetResourceId": "[resourceId('Microsoft.Network/publicIPAddresses',variables('primPIP'))]",
                            "endpointStatus": "Enabled",
                            "target": "[variables('primPIP')]"
                        }
                    },
                    {
                        "name": "Secondary-Endpoint",
                        "type": "Microsoft.Network/trafficManagerProfiles/azureEndpoints",
                        "properties": {
                            "targetResourceId": "[resourceId('Microsoft.Network/publicIPAddresses',variables('secPIP'))]",
                            "endpointStatus": "Enabled",
                            "target": "[variables('secPIP')]"
                        }
                    }
                ]
            }
        },
        {
            "name": "[variables('primSQLServer')]",
            "type": "Microsoft.Sql/servers",
            "apiVersion": "2019-06-01-preview",
            "location": "[variables('primLocation')]",
            "properties": {
                "administratorLogin": "azuresql",
                "administratorLoginPassword": "[parameters('sqlPassword')]",
                "publicNetworkAccess": "Disabled"
            },
            "resources": [
                {
                    "type": "databases",
                    "apiVersion": "2020-08-01-preview",
                    "name": "[variables('dbName')]",
                    "location": "[variables('primLocation')]",
                    "sku": {
                        "name": "Standard",
                        "tier": "Standard"
                    },
                    "properties": {},
                    "dependsOn": [
                        "[resourceId('Microsoft.Sql/servers',variables('primSQLServer'))]"
                    ]
                },
                {
                    "apiVersion": "2020-02-02-preview",
                    "type": "failoverGroups",
                    "name": "[variables('sqlFailoverGroupName')]",
                    "properties": {
                        "serverName": "[variables('primSQLServer')]",
                        "partnerServers": [
                            {
                                "id": "[resourceId('Microsoft.Sql/servers', variables('secSQLServer'))]"
                            }
                        ],
                        "readWriteEndpoint": {
                            "failoverPolicy": "Automatic",
                            "failoverWithDataLossGracePeriodMinutes": 5
                        },
                        "readOnlyEndpoint": {
                            "failoverPolicy": "Disabled"
                        },
                        "databases": [
                            "[resourceId('Microsoft.Sql/servers/databases',variables('primSQLServer'),variables('dbName'))]"
                        ]
                    },
                    "dependsOn": [
                        "[variables('primSQLServer')]",
                        "[resourceId('Microsoft.Sql/servers', variables('secSQLServer'))]",
                        "[variables('primDNSGroup')]",
                        "[variables('secDNSGroup')]",
                        "[variables('dbName')]"
                    ]
                },
                {
                    "type": "connectionPolicies",
                    "apiVersion": "2014-04-01",
                    "name": "Proxy",
                    "dependsOn": [
                        "[resourceId('Microsoft.Sql/servers', variables('primSQLServer'))]"
                    ],
                    "properties": {
                        "connectionType": "Proxy"
                    }
                }
            ]
        },
        {
            "name": "[variables('secSQLServer')]",
            "type": "Microsoft.Sql/servers",
            "apiVersion": "2019-06-01-preview",
            "location": "[variables('secLocation')]",
            "properties": {
                "administratorLogin": "azuresql",
                "administratorLoginPassword": "[parameters('sqlPassword')]",
                "publicNetworkAccess": "Disabled"
            },
            "resources": [
                {
                    "type": "connectionPolicies",
                    "apiVersion": "2014-04-01",
                    "name": "Proxy",
                    "dependsOn": [
                        "[resourceId('Microsoft.Sql/servers', variables('secSQLServer'))]"
                    ],
                    "properties": {
                        "connectionType": "Proxy"
                    }
                }
            ]
        },
        {
            "name": "[variables('primPEName')]",
            "apiVersion": "2020-05-01",
            "dependsOn": [
                "[resourceId('Microsoft.Network/virtualNetworks',variables('primVnet'))]",
                "[resourceId('Microsoft.Sql/servers',variables('primSQLServer'))]"
            ],
            "type": "Microsoft.Network/privateEndpoints",
            "location": "[variables('primLocation')]",
            "properties": {
                "subnet": {
                    "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', variables('primVnet'),'vmSubnet')]"
                },
                "privateLinkServiceConnections": [
                    {
                        "name": "[variables('primPEName')]",
                        "properties": {
                            "privateLinkServiceId": "[resourceId('Microsoft.Sql/servers', variables('primSQLServer'))]",
                            "groupIds": [
                                "sqlServer"
                            ]
                        }
                    }
                ]
            }
        },
        {
            "name": "[variables('secPEName')]",
            "apiVersion": "2020-05-01",
            "dependsOn": [
                "[resourceId('Microsoft.Network/virtualNetworks',variables('secVnet'))]",
                "[resourceId('Microsoft.Sql/servers',variables('secSQLServer'))]"
            ],
            "type": "Microsoft.Network/privateEndpoints",
            "location": "[variables('secLocation')]",
            "properties": {
                "subnet": {
                    "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', variables('secVnet'),'vmSubnet')]"
                },
                "privateLinkServiceConnections": [
                    {
                        "name": "[variables('secPEName')]",
                        "properties": {
                            "privateLinkServiceId": "[resourceId('Microsoft.Sql/servers', variables('secSQLServer'))]",
                            "groupIds": [
                                "sqlServer"
                            ]
                        }
                    }
                ]
            }
        },
        {
            "type": "Microsoft.Network/privateDnsZones",
            "apiVersion": "2020-01-01",
            "name": "[variables('privateDnsZoneName')]",
            "location": "global",
            "dependsOn": [
                "[resourceId('Microsoft.Network/virtualNetworks', variables('primVnet'))]",
                "[resourceId('Microsoft.Network/virtualNetworks',variables('secVnet'))]"
            ],
            "properties": ""
        },
        {
            "type": "Microsoft.Network/privateDnsZones/virtualNetworkLinks",
            "apiVersion": "2020-01-01",
            "name": "[concat(variables('privateDnsZoneName'), '/', variables('privateDnsZoneName'), '-link1')]",
            "location": "global",
            "dependsOn": [
                "[resourceId('Microsoft.Network/privateDnsZones', variables('privateDnsZoneName'))]",
                "[resourceId('Microsoft.Network/virtualNetworks', variables('primVnet'))]"
            ],
            "properties": {
                "registrationEnabled": false,
                "virtualNetwork": {
                    "id": "[resourceId('Microsoft.Network/virtualNetworks', variables('primVnet'))]"
                }
            }
        },
        {
            "type": "Microsoft.Network/privateDnsZones/virtualNetworkLinks",
            "apiVersion": "2020-01-01",
            "name": "[concat(variables('privateDnsZoneName'), '/', variables('privateDnsZoneName'), '-link2')]",
            "location": "global",
            "dependsOn": [
                "[resourceId('Microsoft.Network/privateDnsZones', variables('privateDnsZoneName'))]",
                "[resourceId('Microsoft.Network/virtualNetworks', variables('secVnet'))]"
            ],
            "properties": {
                "registrationEnabled": false,
                "virtualNetwork": {
                    "id": "[resourceId('Microsoft.Network/virtualNetworks', variables('secVnet'))]"
                }
            }
        },
        {
            "type": "Microsoft.Network/privateEndpoints/privateDnsZoneGroups",
            "apiVersion": "2020-06-01",
            "name": "[variables('primDNSGroupName')]",
            "location": "[variables('primLocation')]",
            "dependsOn": [
                "[resourceId('Microsoft.Network/privateDnsZones', variables('privateDnsZoneName'))]",
                "[resourceId('Microsoft.Network/privateEndpoints',variables('primPEName'))]"
            ],
            "properties": {
                "privateDnsZoneConfigs": [
                    {
                        "name": "config1",
                        "properties": {
                            "privateDnsZoneId": "[resourceId('Microsoft.Network/privateDnsZones', variables('privateDnsZoneName'))]"
                        }
                    }
                ]
            }
        },
        {
            "type": "Microsoft.Network/privateEndpoints/privateDnsZoneGroups",
            "apiVersion": "2020-06-01",
            "name": "[variables('secDNSGroupName')]",
            "location": "[variables('secLocation')]",
            "dependsOn": [
                "[resourceId('Microsoft.Network/privateDnsZones', variables('privateDnsZoneName'))]",
                "[resourceId('Microsoft.Network/privateEndpoints',variables('secPEName'))]"
            ],
            "properties": {
                "privateDnsZoneConfigs": [
                    {
                        "name": "config1",
                        "properties": {
                            "privateDnsZoneId": "[resourceId('Microsoft.Network/privateDnsZones', variables('privateDnsZoneName'))]"
                        }
                    }
                ]
            }
        },
        {
            "type": "Microsoft.OperationalInsights/workspaces",
            "name": "[variables('primWSName')]",
            "apiVersion": "2020-08-01",
            "location": "[variables('primLocation')]",
            "properties": {
                "sku": {
                    "name": "perGB2018"
                },
                "retentionInDays": 30,
                "features": {
                    "searchVersion": 1,
                    "legacy": 0,
                    "enableLogAccessUsingOnlyResourcePermissions": true
                }
            }
        },
        {
            "type": "Microsoft.OperationalInsights/workspaces",
            "name": "[variables('secWSName')]",
            "apiVersion": "2020-08-01",
            "location": "[variables('secLocation')]",
            "properties": {
                "sku": {
                    "name": "perGB2018"
                },
                "retentionInDays": 30,
                "features": {
                    "searchVersion": 1,
                    "legacy": 0,
                    "enableLogAccessUsingOnlyResourcePermissions": true
                }
            }
        },
        {
            "type": "Microsoft.Compute/virtualMachines/extensions",
            "apiVersion": "2019-12-01",
            "name": "[concat(variables('primVM1'),'/', variables('daExtensionName'))]",
            "location": "[variables('primLocation')]",
            "dependsOn": [
                "[concat('Microsoft.Compute/virtualMachines/', variables('primVM1'))]"
            ],
            "properties": {
                "publisher": "Microsoft.Azure.Monitoring.DependencyAgent",
                "type": "[variables('daExtensionType')]",
                "typeHandlerVersion": "[variables('daExtensionVersion')]",
                "autoUpgradeMinorVersion": true
            }
        },
        {
            "type": "Microsoft.Compute/virtualMachines/extensions",
            "apiVersion": "2017-12-01",
            "name": "[concat(variables('primVM1'),'/', variables('mmaExtensionName'))]",
            "location": "[variables('primLocation')]",
            "dependsOn": [
                "[concat('Microsoft.Compute/virtualMachines/', variables('primVM1'))]"
            ],
            "properties": {
                "publisher": "Microsoft.EnterpriseCloud.Monitoring",
                "type": "[variables('mmaExtensionType')]",
                "typeHandlerVersion": "[variables('mmaExtensionVersion')]",
                "autoUpgradeMinorVersion": true,
                "settings": {
                    "workspaceId": "[reference(variables('primWSName'), '2015-03-20').customerId]",
                    "stopOnMultipleConnections": true
                },
                "protectedSettings": {
                    "workspaceKey": "[listKeys(variables('primWSName'), '2015-03-20').primarySharedKey]"
                }
            }
        },
        {
            "type": "Microsoft.Compute/virtualMachines/extensions",
            "apiVersion": "2019-12-01",
            "name": "[concat(variables('primVM2'),'/', variables('daExtensionName'))]",
            "location": "[variables('primLocation')]",
            "dependsOn": [
                "[concat('Microsoft.Compute/virtualMachines/', variables('primVM2'))]"
            ],
            "properties": {
                "publisher": "Microsoft.Azure.Monitoring.DependencyAgent",
                "type": "[variables('daExtensionType')]",
                "typeHandlerVersion": "[variables('daExtensionVersion')]",
                "autoUpgradeMinorVersion": true
            }
        },
        {
            "type": "Microsoft.Compute/virtualMachines/extensions",
            "apiVersion": "2017-12-01",
            "name": "[concat(variables('primVM2'),'/', variables('mmaExtensionName'))]",
            "location": "[variables('primLocation')]",
            "dependsOn": [
                "[concat('Microsoft.Compute/virtualMachines/', variables('primVM2'))]"
            ],
            "properties": {
                "publisher": "Microsoft.EnterpriseCloud.Monitoring",
                "type": "[variables('mmaExtensionType')]",
                "typeHandlerVersion": "[variables('mmaExtensionVersion')]",
                "autoUpgradeMinorVersion": true,
                "settings": {
                    "workspaceId": "[reference(variables('primWSName'), '2015-03-20').customerId]",
                    "stopOnMultipleConnections": true
                },
                "protectedSettings": {
                    "workspaceKey": "[listKeys(variables('primWSName'), '2015-03-20').primarySharedKey]"
                }
            }
        },
        {
            "type": "Microsoft.Compute/virtualMachines/extensions",
            "apiVersion": "2019-12-01",
            "name": "[concat(variables('secVM1'),'/', variables('daExtensionName'))]",
            "location": "[variables('secLocation')]",
            "dependsOn": [
                "[concat('Microsoft.Compute/virtualMachines/', variables('secVM1'))]"
            ],
            "properties": {
                "publisher": "Microsoft.Azure.Monitoring.DependencyAgent",
                "type": "[variables('daExtensionType')]",
                "typeHandlerVersion": "[variables('daExtensionVersion')]",
                "autoUpgradeMinorVersion": true
            }
        },
        {
            "type": "Microsoft.Compute/virtualMachines/extensions",
            "apiVersion": "2017-12-01",
            "name": "[concat(variables('secVM1'),'/', variables('mmaExtensionName'))]",
            "location": "[variables('secLocation')]",
            "dependsOn": [
                "[concat('Microsoft.Compute/virtualMachines/', variables('secVM1'))]"
            ],
            "properties": {
                "publisher": "Microsoft.EnterpriseCloud.Monitoring",
                "type": "[variables('mmaExtensionType')]",
                "typeHandlerVersion": "[variables('mmaExtensionVersion')]",
                "autoUpgradeMinorVersion": true,
                "settings": {
                    "workspaceId": "[reference(variables('secWSName'), '2015-03-20').customerId]",
                    "stopOnMultipleConnections": true
                },
                "protectedSettings": {
                    "workspaceKey": "[listKeys(variables('secWSName'), '2015-03-20').primarySharedKey]"
                }
            }
        },
        {
            "type": "Microsoft.Compute/virtualMachines/extensions",
            "apiVersion": "2019-12-01",
            "name": "[concat(variables('secVM2'),'/', variables('daExtensionName'))]",
            "location": "[variables('secLocation')]",
            "dependsOn": [
                "[concat('Microsoft.Compute/virtualMachines/', variables('secVM2'))]"
            ],
            "properties": {
                "publisher": "Microsoft.Azure.Monitoring.DependencyAgent",
                "type": "[variables('daExtensionType')]",
                "typeHandlerVersion": "[variables('daExtensionVersion')]",
                "autoUpgradeMinorVersion": true
            }
        },
        {
            "type": "Microsoft.Compute/virtualMachines/extensions",
            "apiVersion": "2017-12-01",
            "name": "[concat(variables('secVM2'),'/', variables('mmaExtensionName'))]",
            "location": "[variables('secLocation')]",
            "dependsOn": [
                "[concat('Microsoft.Compute/virtualMachines/', variables('secVM2'))]"
            ],
            "properties": {
                "publisher": "Microsoft.EnterpriseCloud.Monitoring",
                "type": "[variables('mmaExtensionType')]",
                "typeHandlerVersion": "[variables('mmaExtensionVersion')]",
                "autoUpgradeMinorVersion": true,
                "settings": {
                    "workspaceId": "[reference(variables('secWSName'), '2015-03-20').customerId]",
                    "stopOnMultipleConnections": true
                },
                "protectedSettings": {
                    "workspaceKey": "[listKeys(variables('secWSName'), '2015-03-20').primarySharedKey]"
                }
            }
        },
        {
            "apiVersion": "2018-06-01",
            "type": "Microsoft.Compute/virtualMachines/extensions",
            "name": "[concat(variables('primVM1'),'/configIIS')]",
            "location": "[variables('primLocation')]",
            "dependsOn": [
                "[variables('primVM1')]"
            ],
            "tags": {
                "displayName": "config-app"
            },
            "properties": {
                "publisher": "Microsoft.Compute",
                "type": "CustomScriptExtension",
                "typeHandlerVersion": "1.10",
                "autoUpgradeMinorVersion": true,
                "settings": {
                    "fileUris": [
                        "https://raw.githubusercontent.com/AmanSextus/infra-automate/main/install-webserver.ps1"
                    ],
                    "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -File install-webserver.ps1",
                    "timestamp": 123456789
                },
                "protectedSettings": {}
            }
        },
        {
            "apiVersion": "2018-06-01",
            "type": "Microsoft.Compute/virtualMachines/extensions",
            "name": "[concat(variables('primVM2'),'/configIIS')]",
            "location": "[variables('primLocation')]",
            "dependsOn": [
                "[variables('primVM2')]"
            ],
            "tags": {
                "displayName": "config-app"
            },
            "properties": {
                "publisher": "Microsoft.Compute",
                "type": "CustomScriptExtension",
                "typeHandlerVersion": "1.10",
                "autoUpgradeMinorVersion": true,
                "settings": {
                    "fileUris": [
                        "https://raw.githubusercontent.com/AmanSextus/infra-automate/main/install-webserver.ps1"
                    ],
                    "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -File install-webserver.ps1",
                    "timestamp": 123456789
                },
                "protectedSettings": {}
            }
        },
        {
            "apiVersion": "2018-06-01",
            "type": "Microsoft.Compute/virtualMachines/extensions",
            "name": "[concat(variables('secVM1'),'/configIIS')]",
            "location": "[variables('secLocation')]",
            "dependsOn": [
                "[variables('secVM1')]"
            ],
            "tags": {
                "displayName": "config-app"
            },
            "properties": {
                "publisher": "Microsoft.Compute",
                "type": "CustomScriptExtension",
                "typeHandlerVersion": "1.10",
                "autoUpgradeMinorVersion": true,
                "settings": {
                    "fileUris": [
                        "https://raw.githubusercontent.com/AmanSextus/infra-automate/main/install-webserver.ps1"
                    ],
                    "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -File install-webserver.ps1",
                    "timestamp": 123456789
                },
                "protectedSettings": {}
            }
        },
        {
            "apiVersion": "2018-06-01",
            "type": "Microsoft.Compute/virtualMachines/extensions",
            "name": "[concat(variables('secVM2'),'/configIIS')]",
            "location": "[variables('secLocation')]",
            "dependsOn": [
                "[variables('secVM2')]"
            ],
            "tags": {
                "displayName": "config-app"
            },
            "properties": {
                "publisher": "Microsoft.Compute",
                "type": "CustomScriptExtension",
                "typeHandlerVersion": "1.10",
                "autoUpgradeMinorVersion": true,
                "settings": {
                    "fileUris": [
                        "https://raw.githubusercontent.com/AmanSextus/infra-automate/main/install-webserver.ps1"
                    ],
                    "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -File install-webserver.ps1",
                    "timestamp": 123456789
                },
                "protectedSettings": {}
            }
        }
    ],
    "outputs": {}
}
